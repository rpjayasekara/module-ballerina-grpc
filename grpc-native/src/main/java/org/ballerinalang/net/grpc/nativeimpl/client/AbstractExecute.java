/*
 *  Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 *  WSO2 Inc. licenses this file to you under the Apache License,
 *  Version 2.0 (the "License"); you may not use this file except
 *  in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing,
 *  software distributed under the License is distributed on an
 *  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 *  KIND, either express or implied.  See the License for the
 *  specific language governing permissions and limitations
 *  under the License.
 */
package org.ballerinalang.net.grpc.nativeimpl.client;

import com.google.protobuf.DescriptorProtos;
import com.google.protobuf.Descriptors;
import io.ballerina.runtime.api.values.BError;
import org.ballerinalang.net.grpc.MessageUtils;
import org.ballerinalang.net.grpc.MethodDescriptor;
import org.ballerinalang.net.grpc.Status;
import org.ballerinalang.net.grpc.exception.GrpcClientException;
import org.ballerinalang.net.grpc.exception.StatusRuntimeException;

/**
 * {@code AbstractExecute} is the Execute action implementation of the gRPC Connector.
 *
 * @since 1.0.0
 */
abstract class AbstractExecute {

    static MethodDescriptor.MethodType getMethodType(Descriptors.MethodDescriptor
                                                      methodDescriptor) throws GrpcClientException {
        DescriptorProtos.MethodDescriptorProto methodDescriptorProto = methodDescriptor.toProto();
        return MessageUtils.getMethodType(methodDescriptorProto);
    }

    static BError notifyErrorReply(Status.Code status, String errorMessage) {
        return MessageUtils.getConnectorError(new StatusRuntimeException(Status
                .fromCode(status).withDescription(errorMessage)));
    }
}
