'use strict';

var { Gateway, Wallets } = require('fabric-network');
const path = require('path');
const FabricCAServices = require('fabric-ca-client');
const fs = require('fs');

const util = require('util');

const getCCP = async (org) => {
    let ccpPath;
    if (org == "Institute1") {
        ccpPath = path.resolve(__dirname, '..', 'config', 'connection-institute1.json');

    } else if (org == "Institute2") {
        ccpPath = path.resolve(__dirname, '..', 'config', 'connection-institute2.json');
    } else if (org == "Institute3") {
        ccpPath = path.resolve(__dirname, '..', 'config', 'connection-institute3.json');
    } else if (org == "Manageral") {
        ccpPath = path.resolve(__dirname, '..', 'config', 'connection-manageral.json');
    } else
        return null
    const ccpJSON = fs.readFileSync(ccpPath, 'utf8')
    const ccp = JSON.parse(ccpJSON);
    return ccp
}

const getCaUrl = async (org, ccp) => {
    let caURL;
    if (org == "Institute1") {
        caURL = ccp.certificateAuthorities['ca.institute1.example.com'].url;

    } else if (org == "Institute2") {
        caURL = ccp.certificateAuthorities['ca.institute2.example.com'].url;
    } else if (org == "Institute3") {
        caURL = ccp.certificateAuthorities['ca.institute3.example.com'].url;
    } else if (org == "Manageral") {
        caURL = ccp.certificateAuthorities['ca.manageral.example.com'].url;
    } else
        return null
    return caURL
    

}

const getWalletPath = async (org) => {
    let walletPath;
    if (org == "Institute1") {
        walletPath = path.join(process.cwd(), 'institute1-wallet');
    } else if (org == "Institute2") {
        walletPath = path.join(process.cwd(), 'institute2-wallet');
    } else if (org == "Institute3") {
        walletPath = path.join(process.cwd(), 'institute3-wallet');
    } else if (org == "Manageral") {
        walletPath = path.join(process.cwd(), 'manageral-wallet');
    } else
        return null
    return walletPath

}


const getAffiliation = async (org) => {
    if (org == 'Manageral') {
        return 'manageral.role'
    } else if (org == 'Institute1') {
        return 'institute1.role'
    } else if (org == 'Institute2') {
        return 'institute2.role'
    } else if (org == 'Institute3') {
        return 'institute3.role'
    }
}

// const getRegisteredUser = async (username, userOrg, isJson) => {
//     let ccp = await getCCP(userOrg)

//     const caURL = await getCaUrl(userOrg, ccp)
//     const ca = new FabricCAServices(caURL);

//     const walletPath = await getWalletPath(userOrg)
//     const wallet = await Wallets.newFileSystemWallet(walletPath);
//     console.log(`Wallet path: ${walletPath}`);

//     const userIdentity = await wallet.get(username);
//     if (userIdentity) {
//         console.log(`An identity for the user ${username} already exists in the wallet`);
//         var response = {
//             success: true,
//             message: username + ' enrolled Successfully',
//         };
//         return response
//     }

//     // Check to see if we've already enrolled the admin user.
//     let adminIdentity = await wallet.get('admin');
//     if (!adminIdentity) {
//         console.log('An identity for the admin user "admin" does not exist in the wallet');
//         await enrollAdmin(userOrg, ccp);
//         adminIdentity = await wallet.get('admin');
//         console.log("Admin Enrolled Successfully")
//     }

//     // build a user object for authenticating with the CA
//     const provider = wallet.getProviderRegistry().getProvider(adminIdentity.type);
//     const adminUser = await provider.getUserContext(adminIdentity, 'admin');
//     let secret;
//     try {
//         // Register the user, enroll the user, and import the new identity into the wallet.
//         secret = await ca.register({ affiliation: await getAffiliation(userOrg), enrollmentID: username, role: 'client' }, adminUser);
//         // const secret = await ca.register({ affiliation: 'org1.role', enrollmentID: username, role: 'client', attrs: [{ name: 'role', value: 'approver', ecert: true }] }, adminUser);

//     } catch (error) {
//         return error.message
//     }

//     const enrollment = await ca.enroll({ enrollmentID: username, enrollmentSecret: secret });
//     // const enrollment = await ca.enroll({ enrollmentID: username, enrollmentSecret: secret, attr_reqs: [{ name: 'role', optional: false }] });

//     let x509Identity = {
//         credentials: {
//             certificate: enrollment.certificate,
//             privateKey: enrollment.key.toBytes(),
//         },
//         mspId: `${org}MSP`,
//         type: 'X.509',
//     };


//     await wallet.put(username, x509Identity);
//     console.log(`Successfully registered and enrolled admin user ${username} and imported it into the wallet`);

//     var response = {
//         success: true,
//         message: username + ' enrolled Successfully',
//     };
//     return response
// }

const getRegisteredUser = async (username, userOrg, role) => {
    let ccp = await getCCP(userOrg)

    const caURL = await getCaUrl(userOrg, ccp)
    console.log("ca url is ", caURL)
    const ca = new FabricCAServices(caURL);

    const walletPath = await getWalletPath(userOrg)
    const wallet = await Wallets.newFileSystemWallet(walletPath);
    console.log(`Wallet path: ${walletPath}`);

    const userIdentity = await wallet.get(username);
    if (userIdentity) {
        console.log(`An identity for the user ${username} already exists in the wallet`);
        var response = {
            message: username + ' enrolled Successfully',
        };
        return response
    }

    // Check to see if we've already enrolled the admin user.
    let adminIdentity = await wallet.get('admin');
    if (!adminIdentity) {
        console.log('An identity for the admin user "admin" does not exist in the wallet');
        await enrollAdmin(userOrg, ccp);
        adminIdentity = await wallet.get('admin');
        console.log("Admin Enrolled Successfully")
    }

    // build a user object for authenticating with the CA
    const provider = wallet.getProviderRegistry().getProvider(adminIdentity.type);
    const adminUser = await provider.getUserContext(adminIdentity, 'admin');
    let secret;
    try {
        // Register the user, enroll the user, and import the new identity into the wallet.
        // secret = await ca.register({ affiliation: await getAffiliation(userOrg), enrollmentID: username, role: 'client' }, adminUser);
        secret = await ca.register({ affiliation: await getAffiliation(userOrg), enrollmentID: username, role: 'client', attrs: [{ name: 'role', value: role, ecert: true }] }, adminUser);

    } catch (error) {
        return error.message
    }

    // const enrollment = await ca.enroll({ enrollmentID: username, enrollmentSecret: secret });
    const enrollment = await ca.enroll({ enrollmentID: username, enrollmentSecret: secret, attr_reqs: [{ name: 'role', optional: false }] });

    let x509Identity = {
        credentials: {
            certificate: enrollment.certificate,
            privateKey: enrollment.key.toBytes(),
        },
        mspId: `${userOrg}MSP`,
        type: 'X.509',
    };
    await wallet.put(username, x509Identity);
    console.log(`Successfully registered and enrolled admin user ${username} and imported it into the wallet`);

    var response = {
        message: username + ' enrolled Successfully',
    };
    return response
}

const isUserRegistered = async (username, userOrg) => {
    const walletPath = await getWalletPath(userOrg)
    const wallet = await Wallets.newFileSystemWallet(walletPath);
    console.log(`Wallet path: ${walletPath}`);

    const userIdentity = await wallet.get(username);
    if (userIdentity) {
        console.log(`An identity for the user ${username} exists in the wallet`);
        return true
    }
    return false
}


const getCaInfo = async (org, ccp) => {
    let caInfo
    if (org == "Institute1") {
        caInfo = ccp.certificateAuthorities['ca.institute1.example.com'];

    } else if (org == "Institute2") {
        caInfo = ccp.certificateAuthorities['ca.institute2.example.com'];
    } else if (org == "Institute3") {
        caInfo = ccp.certificateAuthorities['ca.institute3.example.com'];
    } else if (org == "Manageral") {
        caInfo = ccp.certificateAuthorities['ca.manageral.example.com'];
    } else
        return null
    return caInfo

}

const enrollAdmin = async (org, ccp) => {

    console.log('calling enroll Admin method')

    try {
        const caInfo = await getCaInfo(org, ccp) //ccp.certificateAuthorities['ca.org1.example.com'];
        const caTLSCACerts = caInfo.tlsCACerts.pem;
        const ca = new FabricCAServices(caInfo.url, { trustedRoots: caTLSCACerts, verify: false }, caInfo.caName);

        // Create a new file system based wallet for managing identities.
        const walletPath = await getWalletPath(org) //path.join(process.cwd(), 'wallet');
        const wallet = await Wallets.newFileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);

        // Check to see if we've already enrolled the admin user.
        const identity = await wallet.get('admin');
        if (identity) {
            console.log('An identity for the admin user "admin" already exists in the wallet');
            return;
        }

        // Enroll the admin user, and import the new identity into the wallet.
        const enrollment = await ca.enroll({ enrollmentID: 'admin', enrollmentSecret: 'adminpw' });
        let x509Identity = {
            credentials: {
                certificate: enrollment.certificate,
                privateKey: enrollment.key.toBytes(),
            },
            mspId: `${org}MSP`,
            type: 'X.509',
        };


        await wallet.put('admin', x509Identity);
        console.log('Successfully enrolled admin user "admin" and imported it into the wallet');
        return
    } catch (error) {
        console.error(`Failed to enroll admin user "admin": ${error}`);
    }
}

const registerAndGerSecret = async (username, userOrg) => {
    let ccp = await getCCP(userOrg)

    const caURL = await getCaUrl(userOrg, ccp)
    const ca = new FabricCAServices(caURL);

    const walletPath = await getWalletPath(userOrg)
    const wallet = await Wallets.newFileSystemWallet(walletPath);
    console.log(`Wallet path: ${walletPath}`);

    const userIdentity = await wallet.get(username);
    if (userIdentity) {
        console.log(`An identity for the user ${username} already exists in the wallet`);
        var response = {
            success: true,
            message: username + ' enrolled Successfully',
        };
        return response
    }

    // Check to see if we've already enrolled the admin user.
    let adminIdentity = await wallet.get('admin');
    if (!adminIdentity) {
        console.log('An identity for the admin user "admin" does not exist in the wallet');
        await enrollAdmin(userOrg, ccp);
        adminIdentity = await wallet.get('admin');
        console.log("Admin Enrolled Successfully")
    }

    // build a user object for authenticating with the CA
    const provider = wallet.getProviderRegistry().getProvider(adminIdentity.type);
    const adminUser = await provider.getUserContext(adminIdentity, 'admin');
    let secret;
    try {
        // Register the user, enroll the user, and import the new identity into the wallet.
        secret = await ca.register({ affiliation: await getAffiliation(userOrg), enrollmentID: username, role: 'client' }, adminUser);
        // const secret = await ca.register({ affiliation: 'org1.role', enrollmentID: username, role: 'client', attrs: [{ name: 'role', value: 'approver', ecert: true }] }, adminUser);

    } catch (error) {
        return error.message
    }

    var response = {
        success: true,
        message: username + ' enrolled Successfully',
        secret: secret
    };
    return response

}

exports.getRegisteredUser = getRegisteredUser

module.exports = {
    getCCP: getCCP,
    getWalletPath: getWalletPath,
    enrollAdmin: enrollAdmin,
    getRegisteredUser: getRegisteredUser,
    isUserRegistered: isUserRegistered,
    registerAndGerSecret: registerAndGerSecret

}
