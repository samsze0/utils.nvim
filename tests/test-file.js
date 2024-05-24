// 'hypot' is a binary function
const hypot = (x, y) => Math.sqrt(x * x + y * y);

// 'thunk' is a function that takes no arguments and, when invoked, performs a potentially expensive
// operation (computing a square root, in this example) and/or causes some side-effect to occur
const thunk = () => hypot(3, 4);

// the thunk can then be passed around without being evaluated...
doSomethingWithThunk(thunk);

// ...or evaluated
thunk(); // === 5