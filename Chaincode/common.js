// const privatePayload = new Buffer(JSON.stringify({"Args":args})).toString('base64');
// const result = await contract.createTransaction(func).setTransient({"privatePayload" : privatePayload}).submit();

'use strict';
const {
    Contract
} = require('fabric-contract-api');
const ClientIdentity = require('fabric-shim').ClientIdentity;

class common extends Contract {

    async myAssetExists(ctx, id) {
        const buffer = await ctx.stub.getState(id)
        return (!!buffer && buffer.length > 0);
    }

    async transientData(ctx) {
        let transientData = ctx.stub.getTransient();
        // convert into buffer
        var buffer = new Buffer(transientData.map.conversation.value.toArrayBuffer());// from buffer into string
        var JSONString = buffer.toString('utf8');// from json string into object
        var JSONObject = JSON.parse(JSONString);
        return JSONObject;
    }

    // to fetch unique id everytime
    async IDGenerator(ctx, prefix) {
        let min = 1000000000000;
        let max = 9999999999999;
        let checkid = true;
        while (checkid) {
            let id = Math.floor(Math.random() * (max - min + 1)) + min
            id = prefix + id

            if (this.myAssetExists(ctx, id)) {
                checkid = false;
                return id;
            }
        }
    }

    async postPrivateData(ctx, id, collection, buffer) {
        await ctx.stub.putPrivateData(id, collection, buffer);
        return 'Data added successful';
    }

    async postData(ctx, id, Buffer) {
        await ctx.stub.putState(id, Buffer);
        return 'Data added successful';
    }


    async queryData(ctx, user) {
        let dataAsBytes = await ctx.stub.getState(user);

        if (!dataAsBytes || dataAsBytes.toString().length <= 0) {
            var res = {
                statusCode: 204,
                status: "error",
                data: {}
            }
            return JSON.stringify(res);
        } else {
            let response = JSON.parse(dataAsBytes.toString());
            var res = {
                statusCode: 200,
                status: "success",
                data: response
            }
            return JSON.stringify(res);
        }

    }

    async queryPrivateData(ctx, id, collection) {
        let dataAsBytes = await ctx.stub.getPrivateData(collection, id);

        if (!dataAsBytes || dataAsBytes.toString().length <= 0) {
            var res = {
                statusCode: 204,
                status: "error",
                data: {}
            }
            return JSON.stringify(res);
        } else {
            let response = JSON.parse(dataAsBytes.toString());
            var res = {
                statusCode: 200,
                status: "success",
                data: response
            }
            return JSON.stringify(res);
        }

    }

}

module.exports = common;

