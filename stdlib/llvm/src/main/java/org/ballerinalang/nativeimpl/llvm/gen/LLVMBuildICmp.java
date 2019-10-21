// Copyright (c) 2018 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

package org.ballerinalang.nativeimpl.llvm.gen;

import org.ballerinalang.jvm.values.MapValue;
import org.ballerinalang.nativeimpl.llvm.FFIUtil;
import org.ballerinalang.natives.annotations.Argument;
import org.ballerinalang.natives.annotations.BallerinaFunction;
import org.ballerinalang.natives.annotations.ReturnType;
import org.bytedeco.javacpp.LLVM;
import org.bytedeco.javacpp.LLVM.LLVMValueRef;

import static org.ballerinalang.model.types.TypeKind.INT;
import static org.ballerinalang.model.types.TypeKind.RECORD;
import static org.ballerinalang.model.types.TypeKind.STRING;
import static org.bytedeco.javacpp.LLVM.LLVMBuildICmp;

/**
 * Auto generated class.
 */
@BallerinaFunction(
        orgName = "ballerina", packageName = "llvm",
        functionName = "LLVMBuildICmp",
        args = {
                @Argument(name = "arg0", type = RECORD, structType = "LLVMBuilderRef"),
                @Argument(name = "op", type = INT),
                @Argument(name = "lhs", type = RECORD, structType = "LLVMValueRef"),
                @Argument(name = "rhs", type = RECORD, structType = "LLVMValueRef"),
                @Argument(name = "name", type = STRING),
        },
        returnType = {
                @ReturnType(type = RECORD, structType = "LLVMValueRef", structPackage = "ballerina/llvm"),
        }
)
public class LLVMBuildICmp {

    public static Object llvmBuildICmp(MapValue<String, Object> arg0, long op, MapValue<String, Object> lhs,
            MapValue<String, Object> rhs, String name) {
        LLVM.LLVMBuilderRef arg0Ref = (LLVM.LLVMBuilderRef) FFIUtil.getRecodeArgumentNative(arg0);
        int opRef = (int) op;
        LLVMValueRef lhsRef = (LLVMValueRef) FFIUtil.getRecodeArgumentNative(lhs);
        LLVMValueRef rhsRef = (LLVMValueRef) FFIUtil.getRecodeArgumentNative(rhs);
        LLVMValueRef returnValue = LLVMBuildICmp(arg0Ref, opRef, lhsRef, rhsRef, name);
        MapValue<String, Object> returnWrappedRecord = FFIUtil.newRecord();
        FFIUtil.addNativeToRecode(returnValue, returnWrappedRecord);
        return returnWrappedRecord;
    }
}