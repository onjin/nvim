return {
  lintCommand = "bandit -r -q --skip B101 --format custom --msg-template  '{abspath}:{line}:{col}: {severity}: {msg} bandit[{test_id}]'" ,
	lintFormats = {
    "%f:%l:%c: %tOW: %m",
		"%f:%l:%c: %tEDIUM: %m",
		"%f:%l:%c: %tIGH: %m",
  },
  --[[lintCategoryMap = {
    LOW = "H",
    MEDIUM = "W",
    HIGH = "E",
  },]]
  lintSource = "bandit",
}
