'use strict';
const {
    Contract
} = require('fabric-contract-api');
const ClientIdentity = require('fabric-shim').ClientIdentity;

const Common = require('./common');
const common = new Common();

class criteriaAndCourses extends Contract {
    
    async createCourse(ctx, stream, totalLectures, totalTutorials, totalPracticals, courseProfessor, courseCredits,courseSem,courseSyllabus) {

        var asset = await common.queryData(ctx, instituteId);
        asset = JSON.parse(asset);
        asset = asset.data;

        let str = asset.instituteName;
        let acronym = str.split(/\s/).reduce((response,word)=> response+=word.slice(0,1),'')
        var id = await common.IDGenerator(ctx, acronym);
        let course = {};
        let time = new Date().toISOString().slice(0, 10)
        course = {
            doctype: 'course',
            courseID: id, 
            instituteName: asset.InstituteName, 
            stream: stream, 
            totalLectures: totalLectures, 
            totalTutorials: totalTutorials, 
            totalPracticals: totalPracticals, 
            courseCredits: courseCredits, 
            courseProfessor: courseProfessor, 
            courseSem: courseSem, 
            courseSyllabus: courseSyllabus,
            timeStamp: time
        }

        const temp = await common.postData(ctx, id, Buffer.from(JSON.stringify(course)));

        if (asset.coursesDeployed == []) {
            asset.coursesDeployed[0] = course;
        } else {
            asset.coursesDeployed.push(course);
        }

        const temp1 = await common.postData(ctx, instituteId, Buffer.from(JSON.stringify(asset)));

        var res = {
            status: 'success',
            statusCode: 200,
            message: "Course " + id + " successfully created.",
            data: {
                id: id
            }
        }
        return JSON.stringify(res);

    }

    async updateCourse(ctx, id, field, value) {
        
        var asset1 = await common.queryData(ctx, id);
        asset1 = JSON.parse(asset1);
        asset1 = asset1.data;

        if (field == 'totalLectures') {
            asset1.totalLectures = value;
        }
        else if (field == 'totalTutorials') {
            asset1.totalTutorials = value;
        }
        else if (field == 'totalPracticals') {
            asset1.totalPracticals = value;
        }
        else if (field == 'courseCredits') {
            asset1.courseCredits = value;
        }
        else if (field == 'courseProfessor') {
            asset1.courseProfessor = value;
        }
        else if (field == 'courseSem') {
            asset1.courseSem = value;
        }
        else if (field == 'courseSyllabus') {
            asset1.courseSyllabus = value;
        }

        const temp = await common.postData(ctx, id, Buffer.from(JSON.stringify(asset1)));

        var res = {
            status: 'success',
            statusCode: 200,
            message: "Course " + id + " Updated successfully.",
            data: {
                id: id
            }
        }
        return JSON.stringify(res);

    }

    async admCriteria(ctx, instituteId, stream, maxSeatCount, minimumAge, minimumRankExam, minimumBoardPercent, extras) {

        console.log("here")
        var asset = await common.queryData(ctx, instituteId);
        asset = JSON.parse(asset);
        asset = asset.data;
        
        
        let str = asset.InstituteName;
        let str1 = 'AC'
        let acronym = str.split(/\s/).reduce((response,word)=> response+=word.slice(0,1),'')
        acronym = str1.concat(acronym)
        var id = await common.IDGenerator(ctx, acronym);


        var criteria = {
            doctype: 'admissionCriteria',
            id: id,
            instituteID: instituteId, 
            instituteName: asset.instituteName, 
            stream: stream, 
            maxSeatCount: maxSeatCount, 
            minimumAge: minimumAge, 
            minimumRankExam: minimumRankExam, 
            minimumBoardPercent: minimumBoardPercent, 
            extras: extras
        }

        const temp = await common.postData(ctx, id, Buffer.from(JSON.stringify(criteria)));

        if (asset.admCriteria == []) {
            asset.admCriteria[0] = criteria;
        } else {
            var res = {
                statusCode: 500,
                status: 'error',
                message: 'Admission Criteria already have data',
                data: {}
            }

            return JSON.stringify(res);
        }

        const temp1 = await common.postData(ctx, instituteId, Buffer.from(JSON.stringify(asset)));


        var res = {
            status: 'success',
            statusCode: 200,
            message: "Admission Criteria " + id + " created successfully.",
            data: {
                id: id
            }
        }

        return JSON.stringify(res);
    }

    async updateAdmCriteria(ctx, id, field, value) {
        
        var asset1 = await common.queryData(ctx, id);
        asset1 = JSON.parse(asset1);
        asset1 = asset1.data;
        
        if (field == 'maxSeatCount') {
            asset1.maxSeatCount = value;
        }
        else if (field == 'minimumAge') {
            asset1.minimumAge = value;
        }
        else if (field == 'minimumRankExam') {
            asset1.minimumRankExam = value;
        }
        else if (field == 'minimumBoardPercent') {
            asset1.minimumBoardPercent = value;
        }
        else if (field == 'extras') {
            asset1.extras = value;
        }

        const temp = await common.postData(ctx, id, Buffer.from(JSON.stringify(asset1)));

        var res = {
            status: 'success',
            statusCode: 200,
            message: "Admission Criteria " + id + " Updated successfully.",
            data: {
                id: id
            }
        }
        return JSON.stringify(res);

    }

    async hostChangeCriteria(ctx, instituteId, stream, minimumScore, courses, extras) {

        console.log("here")
        var asset = await common.queryData(ctx, instituteId);
        asset = JSON.parse(asset);
        asset = asset.data;
        
        
        let str = asset.InstituteName;
        let str1 = 'HCC'
        let acronym = str.split(/\s/).reduce((response,word)=> response+=word.slice(0,1),'')
        acronym = str1.concat(acronym)
        var id = await common.IDGenerator(ctx, acronym);


        var criteria = {
            doctype: 'hostChangeCriteria',
            id: id,
            instituteID: instituteId, 
            instituteName: asset.instituteName, 
            stream: stream, 
            minimumScore: minimumScore, 
            courses: courses,
            extras: extras
        }

        const temp = await common.postData(ctx, id, Buffer.from(JSON.stringify(criteria)));

        if (asset.hostChangeCriteria == []) {
            asset.hostChangeCriteria[0] = criteria;
        } else {
            var res = {
                statusCode: 500,
                status: 'error',
                message: 'Host Change Stage already have data',
                data: {}
            }

            return JSON.stringify(res);
        }

        const temp1 = await common.postData(ctx, instituteId, Buffer.from(JSON.stringify(asset)));


        var res = {
            status: 'success',
            statusCode: 200,
            message: "Host Change Criteria " + id + " created successfully.",
            data: {
                id: id
            }
        }


    }

    async updateHostChangeCriteria(ctx, id, field, value) {
        
        var asset1 = await common.queryData(ctx, id);
        asset1 = JSON.parse(asset1);
        asset1 = asset1.data;

        
        if (field == 'minimumScore') {
            asset1.minimumScore = value;
        }
        else if (field == 'courses') {
            asset1.courses = value;
        }
        else if (field == 'extras') {
            asset1.extras = value;
        }

        const temp = await common.postData(ctx, id, Buffer.from(JSON.stringify(asset1)));

        var res = {
            status: 'success',
            statusCode: 200,
            message: "Host Change Criteria " + id + " Updated successfully.",
            data: {
                id: id
            }
        }
        return JSON.stringify(res);

    }

    async dropOutCriteria(ctx, instituteId, stream, minimumScore, courses, extras) {

        console.log("here")
        var asset = await common.queryData(ctx, instituteId);
        asset = JSON.parse(asset);
        asset = asset.data;
        
        
        let str = asset.InstituteName;
        let str1 = 'DOC'
        let acronym = str.split(/\s/).reduce((response,word)=> response+=word.slice(0,1),'')
        acronym = str1.concat(acronym)
        var id = await common.IDGenerator(ctx, acronym);


        var criteria = {
            doctype: 'dropOutCriteria',
            id: id,
            instituteID: instituteId, 
            instituteName: asset.instituteName, 
            stream: stream, 
            minimumScore: minimumScore, 
            courses: courses,
            extras: extras
        }

        const temp = await common.postData(ctx, id, Buffer.from(JSON.stringify(criteria)));

        if (asset.dropOutCriteria == []) {
            asset.dropOutCriteria[0] = criteria;
        } else {
            var res = {
                statusCode: 500,
                status: 'error',
                message: 'Host Change Stage already have data',
                data: {}
            }

            return JSON.stringify(res);
        }

        const temp1 = await common.postData(ctx, instituteId, Buffer.from(JSON.stringify(asset)));


        var res = {
            status: 'success',
            statusCode: 200,
            message: "Host Change Criteria " + id + " created successfully.",
            data: {
                id: id
            }
        }


    }

    async updateDropOutCriteria(ctx, id, field, value) {
        
        var asset1 = await common.queryData(ctx, id);
        asset1 = JSON.parse(asset1);
        asset1 = asset1.data;
        
        if (field == 'minimumScore') {
            asset1.minimumScore = value;
        }
        else if (field == 'courses') {
            asset1.courses = value;
        }
        else if (field == 'extras') {
            asset1.extras = value;
        }

        const temp = await common.postData(ctx, id, Buffer.from(JSON.stringify(asset1)));

        var res = {
            status: 'success',
            statusCode: 200,
            message: "Drop Out Criteria " + id + " Updated successfully.",
            data: {
                id: id
            }
        }
        return JSON.stringify(res);

    }

}


module.exports = criteriaAndCourses;