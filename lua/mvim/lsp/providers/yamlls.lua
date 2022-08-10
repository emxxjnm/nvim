return {
  settings = {
    yaml = {
      format = {
        enable = true,
      },
      validate = true,
      schemas = {
        ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "docker-compose.yml",
        ["https://json.schemastore.org/pre-commit-config.json"] = ".pre-commit-config.yaml",
        kubernetes = "/*.k8s.yaml",
      },
    },
  },
}
