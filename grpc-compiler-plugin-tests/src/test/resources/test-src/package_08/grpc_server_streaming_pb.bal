// Copyright (c) 2021 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.
import ballerina/grpc;

public client class HelloWorldClient {

    *grpc:AbstractClientEndpoint;

    private grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        // initialize client endpoint.
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR, getDescriptorMap());
    }

    isolated remote function lotsOfReplies(string req) returns stream<string, grpc:Error?>|grpc:Error {

        var payload = check self.grpcClient->executeServerStreaming("HelloWorld/lotsOfReplies", req);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        StringStream outputStream = new StringStream(result);
        return new stream<string, grpc:Error?>(outputStream);
    }

    isolated remote function lotsOfRepliesContext(string req) returns ContextStringStream|grpc:Error {

        var payload = check self.grpcClient->executeServerStreaming("HelloWorld/lotsOfReplies", req);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, headers] = payload;
        StringStream outputStream = new StringStream(result);
        return {
            content: new stream<string, grpc:Error?>(outputStream),
            headers: headers
        };
    }
}

public class StringStream {
    private stream<anydata, grpc:Error?> anydataStream;

    public isolated function init(stream<anydata, grpc:Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {| string value; |}|grpc:Error? {
        var streamValue = self.anydataStream.next();
        if (streamValue is ()) {
            return streamValue;
        } else if (streamValue is grpc:Error) {
            return streamValue;
        } else {
            record {| string value; |} nextRecord = {value: <string>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns grpc:Error? {
        return self.anydataStream.close();
    }
}

public client class HelloWorldStringCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendString(string response) returns grpc:Error? {
        return self.caller->send(response);
    }
    isolated remote function sendContextString(ContextString response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }
}

public type ContextStringStream record {|
    stream<string, error?> content;
    map<string|string[]> headers;
|};

public type ContextString record {|
    string content;
    map<string|string[]> headers;
|};

const string ROOT_DESCRIPTOR = "0A1B677270635F7365727665725F73747265616D696E672E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F325B0A0A48656C6C6F576F726C64124D0A0D6C6F74734F665265706C696573121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C75653001620670726F746F33";

isolated function getDescriptorMap() returns map<string> {
    return 
    {
        "grpc_server_streaming.proto": "0A1B677270635F7365727665725F73747265616D696E672E70726F746F1A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F325B0A0A48656C6C6F576F726C64124D0A0D6C6F74734F665265706C696573121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C75653001620670726F746F33",
        "google/protobuf/wrappers.proto": "0A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F120F676F6F676C652E70726F746F62756622230A0B446F75626C6556616C756512140A0576616C7565180120012801520576616C756522220A0A466C6F617456616C756512140A0576616C7565180120012802520576616C756522220A0A496E74363456616C756512140A0576616C7565180120012803520576616C756522230A0B55496E74363456616C756512140A0576616C7565180120012804520576616C756522220A0A496E74333256616C756512140A0576616C7565180120012805520576616C756522230A0B55496E74333256616C756512140A0576616C756518012001280D520576616C756522210A09426F6F6C56616C756512140A0576616C7565180120012808520576616C756522230A0B537472696E6756616C756512140A0576616C7565180120012809520576616C756522220A0A427974657356616C756512140A0576616C756518012001280C520576616C756542570A13636F6D2E676F6F676C652E70726F746F627566420D577261707065727350726F746F50015A057479706573F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33"
    };
}
