import ballerina/log;
import ballerina/time;

stream<Employee> globalEmployeeStream;

type Employee record {
    int id,
    string name,
};

type Person record {
    int id,
    string name,
};

type Job record {
    string description,
};

type Captain object {
    private string name;
    private int id;

    new(name, id) {}

    function logName() {
        log:printInfo(name);
    }
};

type Member object {
    private string name;
    private int id;

    new(name, id) {}

    function logName() {
        log:printInfo(name);
    }
};

type Coach object {
    private string name;
    private int registrationId;
    private float salary;

    new(name, registrationId, salary) {}

    public function logName() {
        log:printInfo(name);
    }
};

function testInvalidRecordPublishingToStream() {
    stream<Employee> s1;
    Job j1 = { description:"Dummy Description 1" };
    s1.publish(j1);
}

function testSubscriptionFunctionWithIncorrectRecordParameter() {
    stream<Employee> s1;
    s1.subscribe(printJobDescription);
}

function testInvalidObjectPublishingToStream() {
    stream<Captain> s1;
    Coach c1 = new("Maryam", 120384, 1000.0);
    s1.publish(c1);
}

function testSubscriptionFunctionWithIncorrectObjectParameter() {
    stream<Captain> s1;
    s1.subscribe(printCoachName);
}

function testSubscriptionFunctionWithUnassignableUnionParameter() {
    stream<int[]|string|boolean|float> unionStream;
    unionStream.subscribe(addToGlobalAnyArrayForUnionType);
}

function testSubscriptionFunctionWithUnassignableTupleTypeParameter() {
    stream<(int, float)> tupleStream;
    tupleStream.subscribe(addToGlobalAnyArrayForTupleType);
}

int arrayIndex = 0;
Employee globalEmployee;

function testGlobalStream() returns (Employee, Employee, Employee) {
    Employee origEmployee = globalEmployee;
    globalEmployeeStream.subscribe(assignGlobalEmployee);
    Employee publishedEmployee = { id:5678, name:"Maryam" };
    globalEmployeeStream.publish(publishedEmployee);
    int startTime = time:currentTime().time;
    while (globalEmployee.id == 0 && time:currentTime().time - startTime < 1000) {
        //allow for value update
    }
    return (origEmployee, publishedEmployee, globalEmployee);
}

function testStreamPublishingAndSubscriptionForRecord() returns (Employee, Employee, Employee) {
    Employee origEmployee = globalEmployee;
    stream<Employee> s1;
    s1.subscribe(assignGlobalEmployee);
    Employee publishedEmployee = { id:1234, name:"Maryam" };
    s1.publish(publishedEmployee);
    int startTime = time:currentTime().time;
    while (globalEmployee.id == 0 && time:currentTime().time - startTime < 1000) {
        //allow for value update
    }
    return (origEmployee, publishedEmployee, globalEmployee);
}

Employee[] globalEmployeeArray = [];

function testStreamPublishingAndSubscriptionForMultipleRecordEvents() returns (Employee[], Employee[]) {
    arrayIndex = 0;
    stream<Employee> s1;
    s1.subscribe(addToGlobalEmployeeArray);
    Employee e1 = { id:1234, name:"Maryam" };
    Employee e2 = { id:2345, name:"Aysha" };
    Employee e3 = { id:3456, name:"Sumayya" };
    Employee[] publishedEmployees = [e1, e2, e3];
    s1.publish(e1);
    s1.publish(e2);
    s1.publish(e3);
    int startTime = time:currentTime().time;
    while (lengthof globalEmployeeArray < 3 && time:currentTime().time - startTime < 5000) {
        //allow for value update
    }
    return (publishedEmployees, globalEmployeeArray);
}

int[] globalIntegerArray = [];

function testStreamPublishingAndSubscriptionForIntegerStream() returns (int[], int[]) {
    arrayIndex = 0;
    stream<int> intStream;
    intStream.subscribe(addToGlobalIntegerArray);
    int[] publishedIntegerEvents = [11, 24857, 0, -1, 999];
    foreach intEvent in publishedIntegerEvents {
        intStream.publish(intEvent);
    }
    int startTime = time:currentTime().time;
    while (lengthof globalIntegerArray < lengthof publishedIntegerEvents && time:currentTime().time - startTime < 5000) {
        //allow for value update
    }
    return (publishedIntegerEvents, globalIntegerArray);
}

boolean[] globalBooleanArray = [];

function testStreamPublishingAndSubscriptionForBooleanStream() returns (boolean[], boolean[]) {
    arrayIndex = 0;
    stream<boolean> booleanStream;
    booleanStream.subscribe(addToGlobalBooleanArray);
    boolean[] publishedBooleanEvents = [true, false, false, true, false];
    foreach booleanEvent in publishedBooleanEvents {
        booleanStream.publish(booleanEvent);
    }
    int startTime = time:currentTime().time;
    while (lengthof globalBooleanArray < lengthof publishedBooleanEvents && time:currentTime().time - startTime < 5000) {
        //allow for value update
    }
    return (publishedBooleanEvents, globalBooleanArray);
}

any[] globalAnyArray = [];

function testStreamPublishingAndSubscriptionForUnionTypeStream() returns (any[], any[]) {
    globalAnyArray = [];
    arrayIndex = 0;
    stream<int[]|string|boolean> unionStream;
    unionStream.subscribe(addToGlobalAnyArrayForUnionType);
    int[] intarray = [1, 2, 3];
    any[] publishedEvents = [intarray, "Maryam", false];
    foreach event in publishedEvents {
        unionStream.publish(event);
    }
    int startTime = time:currentTime().time;
    while (lengthof globalAnyArray < lengthof publishedEvents && time:currentTime().time - startTime < 5000) {
        //allow for value update
    }
    return (publishedEvents, globalAnyArray);
}

function testStreamPublishingAndSubscriptionForAssignableUnionTypeStream(int intVal) returns (any[], any[]) {
    globalAnyArray = [];
    arrayIndex = 0;
    stream<int[]|string|boolean|int> unionStream;
    unionStream.subscribe(addToGlobalAnyArrayForAssignableUnionType);
    int[] intarray = [1, 2, 3];
    any[] publishedEvents = [intarray, "Maryam", false, intVal];
    foreach event in publishedEvents {
        unionStream.publish(event);
    }
    int startTime = time:currentTime().time;
    while (lengthof globalAnyArray < lengthof publishedEvents && time:currentTime().time - startTime < 5000) {
        //allow for value update
    }
    return (publishedEvents, globalAnyArray);
}

function testStreamPublishingAndSubscriptionForTupleTypeStream() returns (any[], any[]) {
    globalAnyArray = [];
    arrayIndex = 0;
    stream<(string, int)> tupleStream;
    tupleStream.subscribe(addToGlobalAnyArrayForTupleType);
    any[] publishedEvents = [("tuple1", 1234), ("tuple2", 9876)];
    foreach event in publishedEvents {
        tupleStream.publish(event);
    }
    int startTime = time:currentTime().time;
    while (lengthof globalAnyArray < lengthof publishedEvents && time:currentTime().time - startTime < 5000) {
        //allow for value update
    }
    return (publishedEvents, globalAnyArray);
}

function testStreamPublishingAndSubscriptionForAssignableTupleTypeStream(string s1, int i1, string s2, int i2) returns
any[] {
    globalAnyArray = [];
    arrayIndex = 0;
    stream<(string, int)> tupleStream;
    tupleStream.subscribe(addToGlobalAnyArrayForAssignableTupleType);
    any[] publishedEvents = [(s1, i1), (s2, i2)];
    foreach event in publishedEvents {
        tupleStream.publish(event);
    }
    int startTime = time:currentTime().time;
    while (lengthof globalAnyArray / 2 < lengthof publishedEvents && time:currentTime().time - startTime < 5000) {
        //allow for value update
    }
    return globalAnyArray;
}

function testStreamPublishingAndSubscriptionForAnyTypeStream() returns (any[], any[]) {
    globalAnyArray = [];
    arrayIndex = 0;
    stream<any> anyStream;
    anyStream.subscribe(addToGlobalAnyArrayForAnyType);
    any[] publishedEvents = [("anyStream", 1234), "any", false, 0.5];
    foreach event in publishedEvents {
        anyStream.publish(event);
    }
    int startTime = time:currentTime().time;
    while (lengthof globalAnyArray < lengthof publishedEvents && time:currentTime().time - startTime < 5000) {
        //allow for value update
    }
    return (publishedEvents, globalAnyArray);
}

function testStreamPublishingAndSubscriptionForUnconstrainedStream() returns (any[], any[]) {
    globalAnyArray = [];
    arrayIndex = 0;
    stream unconstrainedStream;
    unconstrainedStream.subscribe(addToGlobalAnyArrayForAnyType);
    any[] publishedEvents = [("unconstrainedStream", 9876), "unconstrained", true, 10.5];
    foreach event in publishedEvents {
        unconstrainedStream.publish(event);
    }
    int startTime = time:currentTime().time;
    while (lengthof globalAnyArray < lengthof publishedEvents && time:currentTime().time - startTime < 5000) {
        //allow for value update
    }
    return (publishedEvents, globalAnyArray);
}

function testStreamsPublishingForStructurallyEquivalentRecords() returns (any[], any[]) {
    globalEmployeeArray = [];
    arrayIndex = 0;
    stream<Employee> employeeStream;
    employeeStream.subscribe(addPersonToGlobalEmployeeArray);
    Person p1 = { id:3000, name:"Maryam" };
    Person p2 = { id:3003, name:"Ziyad" };
    Person[] publishedEvents = [p1, p2];
    foreach event in publishedEvents {
        employeeStream.publish(event);
    }
    int startTime = time:currentTime().time;
    while (lengthof globalEmployeeArray < lengthof publishedEvents && time:currentTime().time - startTime < 5000) {
        //allow for value update
    }
    return (publishedEvents, globalEmployeeArray);
}

Member[] globalMemberArray = [];

function testStreamsPublishingForStructurallyEquivalentObjects() returns (any[], any[]) {
    globalMemberArray = [];
    arrayIndex = 0;
    stream<Member> memberStream;
    memberStream.subscribe(addCaptainToGlobalMemberArray);
    Captain c1 = new("Maryam", 123456);
    Captain c2 = new("Ziyad", 654321);
    Captain[] publishedCaptains = [c1, c2];
    foreach event in publishedCaptains {
        memberStream.publish(event);
    }
    int startTime = time:currentTime().time;
    while (lengthof globalMemberArray < lengthof publishedCaptains && time:currentTime().time - startTime < 5000) {
        //allow for value update
    }
    return (publishedCaptains, globalMemberArray);
}

function printJobDescription(Job j) {
    log:printInfo(j.description);
}

function printCoachName(Coach c) {
    c.logName();
}

function assignGlobalEmployee (Employee e) {
    globalEmployee = e;
}

function addPersonToGlobalEmployeeArray(Person p) {
    globalEmployeeArray[arrayIndex] = p;
    arrayIndex = arrayIndex + 1;
}

function addToGlobalEmployeeArray (Employee e) {
    globalEmployeeArray[arrayIndex] = e;
    arrayIndex = arrayIndex + 1;
}

function addCaptainToGlobalMemberArray (Captain c) {
    globalMemberArray[arrayIndex] = c;
    arrayIndex = arrayIndex + 1;
}

function addToGlobalBooleanArray (boolean b) {
    globalBooleanArray[arrayIndex] = b;
    arrayIndex = arrayIndex + 1;
}

function addToGlobalIntegerArray (int i) {
    globalIntegerArray[arrayIndex] = i;
    arrayIndex = arrayIndex + 1;
}

function addToGlobalAnyArrayForUnionType(int[]|string|boolean val) {
    globalAnyArray[arrayIndex] = val;
    arrayIndex = arrayIndex + 1;
}

function addToGlobalAnyArrayForAssignableUnionType(int[]|string|boolean|float val) {
    match(val) {
        float f => globalAnyArray[arrayIndex] = f;
        int[]|string|boolean => globalAnyArray[arrayIndex] = val;
    }
    arrayIndex = arrayIndex + 1;
}

function addToGlobalAnyArrayForTupleType((string, int) val) {
    globalAnyArray[arrayIndex] = val;
    arrayIndex = arrayIndex + 1;
}

function addToGlobalAnyArrayForAssignableTupleType((json, float) val) {
    json jsonVal;
    float floatVal;
    (jsonVal, floatVal) = val;
    globalAnyArray[arrayIndex] = jsonVal;
    arrayIndex = arrayIndex + 1;
    globalAnyArray[arrayIndex] = floatVal;
    arrayIndex = arrayIndex + 1;
}

function addToGlobalAnyArrayForAnyType (any val) {
    globalAnyArray[arrayIndex] = val;
    arrayIndex = arrayIndex + 1;
}
