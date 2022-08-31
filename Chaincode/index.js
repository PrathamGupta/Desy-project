'use strict';

const criteriaAndCourses = require('./criteriaAndCourses');
const enrollment = require('./enrollment');
const credit = require('./credit')
const common = require('./common');
const institute = require('./institute');

module.exports.CriteriaAndCourse = criteriaAndCourses;
module.exports.Common = common;
module.exports.Enrollment = enrollment;
module.exports.Institute = institute;
module.exports.Credit = credit;
module.exports.contracts = [criteriaAndCourses, enrollment, institute, credit, common];