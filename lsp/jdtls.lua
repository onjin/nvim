return {
  root_markers = {".git", "gradlew", "mvnw"},
  cmd = {"jdtls"},
  filetypes = {"java"},
  init_options = {
    extendedClientCapabilities = {
  classFileContentsSupport = true,
  generateToStringPromptSupport = true,
  hashCodeEqualsPromptSupport = true,
  advancedExtractRefactoringSupport = true,
  advancedOrganizeImportsSupport = true,
  generateConstructorsPromptSupport = true,
  generateDelegateMethodsPromptSupport = true,
  moveRefactoringSupport = true,
  overrideMethodsPromptSupport = true,
  executeClientCommandSupport = true,
  inferSelectionSupport = {
    "extractMethod",
    "extractVariable",
    "extractConstant",
    "extractVariableAllOccurrence"
  },

  },
  },
  settings = {
    java = vim.empty_dict(),
  },
}
