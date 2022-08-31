'use strict';
const {
    Contract
} = require('fabric-contract-api');
const ClientIdentity = require('fabric-shim').ClientIdentity;

const Common = require('./common');
const common = new Common();

class institutes extends Contract {
    
    async registerInstitute(ctx, name, address, tier) {

        var data = {}
        let prefix = "I01"
        var id = await common.IDGenerator(ctx, prefix);

        data = {
            doctype: 'instituteDetails',
            id: id,
            instituteName: name,
            instituteAddress: address,
            instituteTier: tier,
            partners: [],
            coursesDeployed: [],
            dropOutStudents: [],
            degreeCompleted: [],
            degreeCriteria: [],
            admCriteria: [],
            hostChangeCriteria: [],
            dropOutCriteria: []
        }



        const temp = await common.postData(ctx, id, Buffer.from(JSON.stringify(data)));


        var res = {
            status: 'success',
            statusCode: 200,
            message: "Institute " + id + " successfully registered.",
            data: {
                id: id
            }
        }
        return JSON.stringify(res);

    }

    async addPartners(ctx, hId, instituteId) {
        
        var asset1 = await common.queryData(ctx, hId);
        asset1 = JSON.parse(asset1);
        asset1 = asset1.data;

        var asset = await common.queryData(ctx, instituteId);
        asset = JSON.parse(asset);
        asset = asset.data;

        var data = {};

        data = {
            id: instituteId,
            name: asset.name
        };

        if (asset1.partners == []) {
            asset1.partners[0] = data;
        } else {
            asset1.partners.push(data);
        }

        const temp = await common.postData(ctx, hId, Buffer.from(JSON.stringify(asset1)));

        var res = {
            status: 'success',
            statusCode: 200,
            message: "Partner Institute Successfully added",
            data: {
                id: id
            }
        }
        return JSON.stringify(res);

    }

    async deletePartners(ctx, hId, instituteId) {
        
        var asset1 = await common.queryData(ctx, hId);
        asset1 = JSON.parse(asset1);
        asset1 = asset1.data;

        var asset = await common.queryData(ctx, instituteId);
        asset = JSON.parse(asset);
        asset = asset.data;

        var data = {};

        data = {
            id: instituteId,
            name: asset.name
        };

        let obj = asset1.partners.find(o => o.name === asset.name);
        if (len(obj) >= 0) {
            asset1.partners = asset1.partners.filter(item => item.name != data.name)
        }

        const temp = await common.postData(ctx, hId, Buffer.from(JSON.stringify(asset1)));

        var res = {
            status: 'success',
            statusCode: 200,
            message: "Partner Institute Successfully removed",
            data: {
                id: id
            }
        }
        return JSON.stringify(res);

    }

}


module.exports = institutes;