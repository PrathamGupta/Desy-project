'use strict';
const {
    Contract
} = require('fabric-contract-api');
const ClientIdentity = require('fabric-shim').ClientIdentity;

const Common = require('./common');
const common = new Common();

class credits extends Contract{
    
    //by institute
    async updateCredits(ctx, id, instituteName, courseId, completionCerti) {

        var asset = await common.queryData(ctx, courseId);
        asset = JSON.parse(asset);
        asset = asset.data;
        

        
        
        var studentData = await common.getPrivateData(ctx, id, instituteName+'_db');
        studentData = JSON.parse(studentData);
        studentData = studentData.data;

        //Updating Credits in total credits
        if (studentData.totalCredits == '') {
            studentData.totalCredits = asset.courseCredits;
        }
        else {
            studentData.totalCredits = studentData.totalCredits + asset.courseCredits;
        }

        //Updating Course Completed Host/Partner
        if (studentData.instituteName == asset.instituteName) {
            studentData.coursesCompletedHost.push(courseId);
        } else {
            studentData.coursesCompletedPartner.push(courseId);
        }

        //Changing the status in courses list
        for (let index = 0; index < studentData.courses.length; index++) {
            // const element = studentData.courses[index];
            if (studentData.courses[index].courseId == courseId) {
                studentData.courses[index].status = 'completed';
                studentData.courses[index].completionCerti = completionCerti;
            } else {
                var res = {
                    status: 'error',
                    statusCode: 500,
                    message: "Course Not found in the list",
                    data: {}
                };
                return JSON.stringify(res);
            }
            
        }



        const temp = await common.postPrivateData(ctx, id, instituteName+'_db', Buffer.from(JSON.stringify(studentData)));

        var res = {
            status: 'success',
            statusCode: 200,
            message: "Credits of Student " + id + " for course "+ courseId + " successfully updated.",
            data: {
                id: id
            }
        }
        return JSON.stringify(res);


    }


}


module.exports = credits;