'use strict';
const {
    Contract
} = require('fabric-contract-api');
const ClientIdentity = require('fabric-shim').ClientIdentity;

const Common = require('./common');
const common = new Common();

class changeStudent extends Contract {
    
    async hostChangeRequest(ctx, id, instituteName) {
        
        var tData = await common.transientData(ctx);
        let collection = tData.instituteName+'_db'
        var studentData = await common.getPrivateData(ctx, id, collection);
        studentData = JSON.parse(studentData);
        studentData = studentData.data;

        let acronym = 'HCR'
        var id1 = await common.IDGenerator(ctx, acronym);

        var data = {
            doctype: 'hostChangeRequest',
            requestId: id1,
            newInstituteName: instituteName,
            currentInstitute: studentData.instituteName,
            studentRollNO: id,
            studentData: [],
            status: 'Initiated'
        };

        const temp = await common.postPrivateData(ctx, id1, 'prospective_student', Buffer.from(JSON.stringify(data)));

        //Updating Course Data in Student Data
        if (studentData.hostChangeRequestID == []) {
            studentData.hostChangeRequestID[0] = id1;
        }
        else {
            studentData.courses.push(id1);
        }

        const temp = await common.postPrivateData(ctx, id, instituteName+'_db', Buffer.from(JSON.stringify(studentData)));

        var res = {
            status: 'success',
            statusCode: 200,
            message: "Student " + id1 + " has successfully requested for Host Change.",
            data: {
                id: id1
            }
        }
        return JSON.stringify(res);


    }

    async updateHostChangeRequest(ctx, id, instituteId) {

        var requestData = await common.getPrivateData(ctx, id, 'prospective_student');
        requestData = JSON.parse(requestData)
        requestData = requestData.data

        let collection = requestData.currentInstitute+'_db'
        let collection1 = requestData.newInstituteName+'_db'
        var studentData = await common.getPrivateData(ctx, requestData.studentRollNO, collection);
        studentData = JSON.parse(studentData);
        studentData = studentData.data;

        var instituteDetails = await common.queryData(ctx, instituteId);
        instituteDetails = JSON.parse(instituteDetails);
        instituteDetails = instituteDetails.data;

        var hcCriteria = instituteDetails.hostChangeCriteria[0]

        if (hcCriteria.minimumScore >= studentData.cgpa) {
            requestData.status = 'Rejected: CGPA is less than minimum score for Host Change'
            const temp = await common.postPrivateData(ctx, id, 'prospective_student', Buffer.from(JSON.stringify(requestData)));
            
            var res = {
                statusCode: 500,
                status: 'error',
                message: 'CGPA is less than minimum score for Host Change',
                data: {}
            }

            return JSON.stringify(res);
        }

        requestData.status = 'Passed to Institute'
        requestData.studentData.push(studentData)

        const temp = await common.postPrivateData(ctx, id, 'prospective_student', Buffer.from(JSON.stringify(requestData)));

        const temp1 = await common.postPrivateData(ctx, id, collection1, Buffer.from(JSON.stringify(requestData)));

        var res = {
            status: 'success',
            statusCode: 200,
            message: "Student " + id1 + " request for host change has been successfully passed to new Institute.",
            data: {
                id: id1
            }
        }
        return JSON.stringify(res);

    }

    async hostChangeDecision(ctx, id, decision) {

        var tData = await common.transientData(ctx);
        let collection = tData.instituteName+'_db'
        
        var requestData = await common.getPrivateData(ctx, id, collection);
        requestData = JSON.parse(requestData)
        requestData = requestData.data

        if (decision == 'accepted') {
            requestData.status = 'Request is Accepted and Student Host is Changed'
            const temp1 = await common.postPrivateData(ctx, id, collection, Buffer.from(JSON.stringify(requestData)));
            var res = {
                status: 'success',
                statusCode: 200,
                message: "Student " + id1 + " request for host change status has been updated",
                data: {
                    id: id
                }
            }
            return JSON.stringify(res);
        }
        else {
            requestData.status = 'Request is Rejected and Student Host is Changed'
            const temp1 = await common.postPrivateData(ctx, id, collection, Buffer.from(JSON.stringify(requestData)));
            var res = {
                status: 'success',
                statusCode: 200,
                message: "Student " + id1 + " request for host change status has been updated",
                data: {
                    id: id
                }
            }
            return JSON.stringify(res);
        }

    }

    async studentDataTransfer(ctx, id){
        var requestData = await common.getPrivateData(ctx, id, 'prospective_student');
        requestData = JSON.parse(requestData)
        requestData = requestData.data

        let str = requestData.newInstituteName;
        let acronym = str.split(/\s/).reduce((response,word)=> response+=word.slice(0,1),'')
        
        var id1 = 'S01'+acronym+String(Math.floor(Date.now() / 1000));

        requestData.studentData.rollNo = id1
        requestData.studentData.instituteName = requestData.newInstituteName

        let collectionName1 = requestData.newInstituteName+'_db';
        const temp1 = await common.postPrivateData(ctx, id1, collectionName1, Buffer.from(JSON.stringify(requestData)));

        requestData.status = 'Student Host is Changed to '+ requestData.newInstituteName
        
        const temp = await common.postPrivateData(ctx, id, 'prospective_student', Buffer.from(JSON.stringify(requestData)));

        const temp1 = await common.postPrivateData(ctx, id, collection1, Buffer.from(JSON.stringify(requestData)));


        var res = {
            status: 'success',
            statusCode: 200,
            message: "Student " + id1 + " is added in "+ requestData.newInstituteName + " admitted list successfully.",
            data: {
                id: id1
            }
        }
        return JSON.stringify(res);
    }


}


module.exports = changeStudent;