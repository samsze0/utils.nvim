local oop_utils = require("utils.oop")

-- T.assert_eq(oop_utils.is_instance({}, {}), false)
-- T.assert_eq(oop_utils.is_instance({}, nil), false)
-- local Parent = oop_utils.new_class()
-- Parent.__name = "Parent"
-- local p = setmetatable({}, Parent)
-- T.assert_eq(oop_utils.is_instance({}, Parent), false)
-- T.assert_eq(oop_utils.is_instance({}, Parent, { is_parent = true }), false)
-- T.assert_eq(oop_utils.is_instance(Parent, Parent), false)
-- T.assert_eq(oop_utils.is_instance(Parent, Parent, { is_parent = true }), false)
-- T.assert_eq(oop_utils.is_instance(p, Parent), true)
-- T.assert_eq(oop_utils.is_instance(p, Parent, { is_parent = true }), true)
-- local Child = oop_utils.new_class(Parent)
-- Child.__name = "Child"
-- T.assert_eq(oop_utils.is_instance(Child, Parent), false)
-- T.assert_eq(oop_utils.is_instance(Child, Parent, { is_parent = true }), false)
-- T.assert_eq(oop_utils.is_instance(Child, Child), false)
-- T.assert_eq(oop_utils.is_instance(Child, Child, { is_parent = true }), false)
-- local c = setmetatable({}, Child)
-- T.assert_eq(oop_utils.is_instance(p, Child), false)
-- T.assert_eq(oop_utils.is_instance(p, Child, { is_parent = true }), false)
-- T.assert_eq(oop_utils.is_instance(c, Child), true)
-- T.assert_eq(oop_utils.is_instance(c, Child, { is_parent = true }), true)
-- T.assert_eq(oop_utils.is_instance(c, Parent), true)
-- T.assert_eq(oop_utils.is_instance(c, Parent, { is_parent = true }), false)
-- T.assert_eq(oop_utils.is_instance(c, Child), true)
-- T.assert_eq(oop_utils.is_instance(c, Child, { is_parent = true }), true)
