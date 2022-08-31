'use strict';
const {
    Contract
} = require('fabric-contract-api');
const ClientIdentity = require('fabric-shim').ClientIdentity;

const Common = require('./common');
const common = new Common();

class enrollment extends Contract{
    
    //by manageral
    async prospectiveStudent(ctx) {

        var tData = await common.transientData(ctx);

        let str = tData.instituteName;
        let acronym = str.split(/\s/).reduce((response,word)=> response+=word.slice(0,1),'')
        var id = await common.IDGenerator(ctx, acronym);

        var data = {
            doctype: 'prospectiveStudent',
            applicationNumber: id,
            instituteName: tData.instituteName,
            name: tData.name,
            dob: tData.dob,
            gender: tData.gender,
            email: tData.email,
            mobileNo: tData.mobileNo,
            aadharNo: tData.aadharNo,
            marksheet10: tData.marksheet10,
            marksheet12: tData.marksheet12,
            entranceResult: tData.entranceResult,
            achievements: tData.achievements,
            degree: tData.degree,
            status: 'unverified'
        };

        
        const temp = await common.postPrivateData(ctx, id, 'prospective_student', Buffer.from(JSON.stringify(data)));

        var res = {
            status: 'success',
            statusCode: 200,
            message: "Prospective Student " + id + " successfully created.",
            data: {
                id: id
            }
        }
        return JSON.stringify(res);


    }

    //by manageral
    async updateStatus(ctx, id) {
        var data = await common.getPrivateData(ctx, id, 'prospective_student');
        data = JSON.parse(data);
        data = data.data;

        data.status = 'verified';

        const temp = await common.postPrivateData(ctx, id, 'prospective_student', Buffer.from(JSON.stringify(data)));

        var data1 = {
            docType: data.instituteName+'ProspectiveStudent',
            applicationNumber: id,
            instituteName: data.instituteName,
            name: data.name,
            dob: data.dob,
            gender: data.gender,
            email: data.email,
            mobileNo: data.mobileNo,
            aadharNo: data.aadharNo,
            marksheet10: data.marksheet10,
            marksheet12: data.marksheet12,
            entranceResult: data.entranceResult,
            achievements: data.achievements,
            status: data.status,
            degree: data.degree,
            admission: 'pending'
        };

        let collectionName = data.instituteName+'_prospective_student';
        const temp1 = await common.postPrivateData(ctx, id, collectionName, Buffer.from(JSON.stringify(data1)));


        var res = {
            status: 'success',
            statusCode: 200,
            message: "Prospective Student " + id + " is added in "+ data.instituteName + " prospective list successfully.",
            data: {
                id: id
            }
        }
        return JSON.stringify(res);


    }

    //by institute
    async updateAdmission(ctx, id, result) {
        var data = await common.getPrivateData(ctx, id, collection);
        data = JSON.parse(data);
        data = data.data;

        data.admission = result;
        let collectionName = data.instituteName+'_prospective_student'

        const temp = await common.postPrivateData(ctx, id, collectionName, Buffer.from(JSON.stringify(data)));

        let str = data.instituteName;
        let acronym = str.split(/\s/).reduce((response,word)=> response+=word.slice(0,1),'')
        
        var id1 = 'S01'+acronym+String(Math.floor(Date.now() / 1000));
        var data1 = {
            rollNo: id1,
            instituteName: data.instituteName,
            name: data.name,
            dob: data.dob,
            gender: data.gender,
            email: data.email,
            mobileNo: data.mobileNo,
            aadharNo: data.aadharNo,
            marksheet10: data.marksheet10,
            marksheet12: data.marksheet12,
            entranceResult: data.entranceResult,
            achievements: data.achievements,
            degree: data.degree,
            status: data.status,
            coursesCompletedHost: [],
            coursesCompletedPartner: [],
            totalCredits: '',
            hostChangeRequestID: [],
            cgpa: '',
            courses: [],
            extras: []
        };

        let collectionName1 = data.instituteName+'_db';
        const temp1 = await common.postPrivateData(ctx, id1, collectionName1, Buffer.from(JSON.stringify(data1)));


        var res = {
            status: 'success',
            statusCode: 200,
            message: "Student " + id1 + " is added in "+ data.instituteName + " admitted list successfully.",
            data: {
                id: id1
            }
        }
        return JSON.stringify(res);


    }


    async courseEnroll(ctx, id, courseId) {
        var asset = await common.queryData(ctx, courseId);
        asset = JSON.parse(asset);
        asset = asset.data;
        
        
        var studentData = await common.getPrivateData(ctx, id, asset.instituteName+'_db');
        studentData = JSON.parse(studentData);
        studentData = studentData.data;
        let time = new Date().toISOString().slice(0, 10)

        var data = {
            courseId: courseId,
            courseName: asset.courseName,
            instituteName: asset.instituteName,
            status: 'Pursuing',
            dataOfEnrollment: time,
            completionCerti: ''
        };

        //Updating Course Data in Student Data
        if (studentData.courses == []) {
            studentData.courses[0] = data;
        }
        else {
            studentData.courses.push(data);
        }

        const temp = await common.postPrivateData(ctx, id, instituteName+'_db', Buffer.from(JSON.stringify(studentData)));

    }

}

module.exports = enrollment;