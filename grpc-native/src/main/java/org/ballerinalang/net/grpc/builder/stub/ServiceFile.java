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

package org.ballerinalang.net.grpc.builder.stub;

import java.util.ArrayList;
import java.util.List;

/**
 * Service file definition bean class.
 */
public class ServiceFile extends AbstractStub {

    private ServiceFile() {
    }

    public static ServiceFile.Builder newBuilder(String serviceName) {
        return new ServiceFile.Builder(serviceName);
    }

    /**
     * Service file definition builder.
     */
    public static class Builder {
        String serviceName;
        List<Method> methodList = new ArrayList<>();

        private Builder(String serviceName) {
            this.serviceName = serviceName;
        }

        public void addMethod(Method method) {
            methodList.add(method);
        }
    }
}
