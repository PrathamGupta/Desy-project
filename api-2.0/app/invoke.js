const { Gateway, Wallets, TxEventHandler, GatewayOptions, DefaultEventHandlerStrategies, TxEventHandlerFactory } = require('fabric-network');
const fs = require('fs');
const path = require("path")
const log4js = require('log4js');
const logger = log4js.getLogger('BasicNetwork');
const util = require('util')

const helper = require('./helper');
// const institutes = require('../../Chaincode/institutes');

const invokeTransaction = async (channelName, chaincodeName, fcn, args, username, org_name, transientData) => {
    try {
        logger.debug(util.format('\n============ invoke transaction on channel %s ============\n', channelName));

        // load the network configuration
        // const ccpPath =path.resolve(__dirname, '..', 'config', 'connection-org1.json');
        // const ccpJSON = fs.readFileSync(ccpPath, 'utf8')
        const ccp = await helper.getCCP(org_name) //JSON.parse(ccpJSON);
        console.log(org_name)
        // Create a new file system based wallet for managing identities.
        const walletPath = await helper.getWalletPath(org_name) //path.join(process.cwd(), 'wallet');
        const wallet = await Wallets.newFileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);

        // Check to see if we've already enrolled the user.
        let identity = await wallet.get(username);
        // console.log(identity)
        if (!identity) {
            console.log(`An identity for the user ${username} does not exist in the wallet, so registering user`);
            await helper.getRegisteredUser(username, org_name, true)
            identity = await wallet.get(username);
            console.log('Run the registerUser.js application before retrying');
            return;
        }

        

        const connectOptions = {
            wallet, identity: username, discovery: { enabled: true, asLocalhost: true },
            eventHandlerOptions: {
                commitTimeout: 100,
                strategy: DefaultEventHandlerStrategies.NETWORK_SCOPE_ALLFORTX
            }
            // transaction: {
            //     strategy: createTransactionEventhandler()
            // }
        }
        // console.log(connectOptions)



        // Create a new gateway for connecting to our peer node.
        const gateway = new Gateway();
        await gateway.connect(ccp, connectOptions);

        // Get the network (channel) our contract is deployed to.
        const network = await gateway.getNetwork(channelName);
        // console.log('uo')
        // console.log(network)
        // console.log("bye")
        const institute = network.getContract(chaincodeName, 'institutes');
        const credit = network.getContract(chaincodeName, 'credit')
        const enrollment = network.getContract(chaincodeName, 'enrollment')
        const criteriaandcourses = network.getContract(chaincodeName, 'criteriaAndCourses')
        const common = network.getContract(chaincodeName, 'common')
        // console.log(institute)
        // console.log(contract)

        let result
        let message;

        
        if (fcn === "registerInstitute") {
            
            console.log("hi")
            result = await institute.submitTransaction(fcn, args.name, args.address, args.tier);
        }

        if (fcn === "prospectiveStudent") {

            console.log("hi")
            result = await enrollment.submitTransaction(fcn)
        }
        
        if (fcn === "admCriteria"){

            console.log("hihello")
            result = await criteriaandcourses.submitTransaction(fcn, args.instituteId, args.stream, args.maxSeatCount, args.minimumAge, args.minimumRankExam, args.minimumBoardPercent, args.extras )

        }
        
        if (fcn === "createCourse"){

            console.log("hi")
            result = await criteriaandcourses.submitTransaction(fcn, args.stream, args.totalLectures, args.totalTutorials, args.totalPracticals, args.courseProfessor, args.courseCredits, args.courseSem, args.courseSyllabus)

        }

        if (fcn === "updateCourse" ){

            console.log("hi")
            result = await criteriaandcourses.submitTransaction(fcn, args.id, args.field, args.value)

        }

        
        
        // app.get('/studentonboarding', function (req, res) {
        
        //     res.render('studentonboarding')
        
        // });
        
        // app.get('/queryapplications', function (req, res) {
        
        //     res.render('queryapplications')
        
        // });
        
        // app.get('/transferapplications', function (req, res) {
        
        //     res.render('transferapplications')
        
        // });


        // else if (fcn === "createCar" || fcn === "createPrivateCarImplicitForOrg1"
        //     || fcn == "createPrivateCarImplicitForOrg2") {
        //     result = await contract.submitTransaction(fcn, args[0], args[1], args[2], args[3], args[4]);
        //     message = `Successfully added the car asset with key ${args[0]}`

        // } else if (fcn === "changeCarOwner") {
        //     result = await contract.submitTransaction(fcn, args[0], args[1]);
        //     message = `Successfully changed car owner with key ${args[0]}`
        // } else if (fcn == "createPrivateCar" || fcn =="updatePrivateData") {
        //     console.log(`Transient data is : ${transientData}`)
        //     let carData = JSON.parse(transientData)
        //     console.log(`car data is : ${JSON.stringify(carData)}`)
        //     let key = Object.keys(carData)[0]
        //     const transientDataBuffer = {}
        //     transientDataBuffer[key] = Buffer.from(JSON.stringify(carData.car))
        //     result = await contract.createTransaction(fcn)
        //         .setTransient(transientDataBuffer)
        //         .submit()
        //     message = `Successfully submitted transient data`
        // }
        // else {
        //     return `Invocation require either createCar or changeCarOwner as function but got ${fcn}`
        // }

        await gateway.disconnect();

        result = JSON.parse(result.toString());

        // let response = {
        //     message: message,
        //     result
        // }

        return result;


    } catch (error) {

        console.log(`Getting error: ${error}`)
        return error.message

    }
}

exports.invokeTransaction = invokeTransaction;