module "ssm-admin-backend" {
  source               = "../modules/ssm"
  PROJECT_NAME         = var.PROJECT_NAME
  ENV                  = var.ENV
  PROJECT_SERVICE_TYPE = var.PROJECT_SERVICES.BACKEND_ADMIN
  ENV_LIST = {
    (var.ADMIN_BACKEND_ENV_SSM.JWT_ACCESS_TOKEN_SECRET.name) : {
      name : "/${var.PROJECT_NAME}/${var.ENV}/${var.PROJECT_SERVICES.BACKEND_ADMIN}/${lower(split("_", var.ADMIN_BACKEND_ENV_SSM.JWT_ACCESS_TOKEN_SECRET.name)[0])}/${lower(var.ADMIN_BACKEND_ENV_SSM.JWT_ACCESS_TOKEN_SECRET.name)}",
      description : var.ADMIN_BACKEND_ENV_SSM.JWT_ACCESS_TOKEN_SECRET.description,
      type : var.ADMIN_BACKEND_ENV_SSM.JWT_ACCESS_TOKEN_SECRET.type
      value : var.ADMIN_BACKEND_ENV_SSM.JWT_ACCESS_TOKEN_SECRET.value
    },
    (var.ADMIN_BACKEND_ENV_SSM.JWT_REFRESH_TOKEN_SECRET.name) : {
      name : "/${var.PROJECT_NAME}/${var.ENV}/${var.PROJECT_SERVICES.BACKEND_ADMIN}/${lower(split("_", var.ADMIN_BACKEND_ENV_SSM.JWT_REFRESH_TOKEN_SECRET.name)[0])}/${lower(var.ADMIN_BACKEND_ENV_SSM.JWT_REFRESH_TOKEN_SECRET.name)}",
      description : var.ADMIN_BACKEND_ENV_SSM.JWT_REFRESH_TOKEN_SECRET.description,
      type : var.ADMIN_BACKEND_ENV_SSM.JWT_REFRESH_TOKEN_SECRET.type
      value : var.ADMIN_BACKEND_ENV_SSM.JWT_REFRESH_TOKEN_SECRET.value
    },
    (var.ADMIN_BACKEND_ENV_SSM.POSTGRES_DB_HOST.name) : {
      name : "/${var.PROJECT_NAME}/${var.ENV}/${var.PROJECT_SERVICES.BACKEND_ADMIN}/${lower(split("_", var.ADMIN_BACKEND_ENV_SSM.POSTGRES_DB_HOST.name)[0])}/${lower(var.ADMIN_BACKEND_ENV_SSM.POSTGRES_DB_HOST.name)}",
      description : var.ADMIN_BACKEND_ENV_SSM.POSTGRES_DB_HOST.description,
      type : var.ADMIN_BACKEND_ENV_SSM.POSTGRES_DB_HOST.type
      value : var.ADMIN_BACKEND_ENV_SSM.POSTGRES_DB_HOST.value
    },
    (var.ADMIN_BACKEND_ENV_SSM.POSTGRES_DB_NAME.name) : {
      name : "/${var.PROJECT_NAME}/${var.ENV}/${var.PROJECT_SERVICES.BACKEND_ADMIN}/${lower(split("_", var.ADMIN_BACKEND_ENV_SSM.POSTGRES_DB_NAME.name)[0])}/${lower(var.ADMIN_BACKEND_ENV_SSM.POSTGRES_DB_NAME.name)}",
      description : var.ADMIN_BACKEND_ENV_SSM.POSTGRES_DB_NAME.description,
      type : var.ADMIN_BACKEND_ENV_SSM.POSTGRES_DB_NAME.type
      value : var.ADMIN_BACKEND_ENV_SSM.POSTGRES_DB_NAME.value
    },
    (var.ADMIN_BACKEND_ENV_SSM.POSTGRES_DB_USER.name) : {
      name : "/${var.PROJECT_NAME}/${var.ENV}/${var.PROJECT_SERVICES.BACKEND_ADMIN}/${lower(split("_", var.ADMIN_BACKEND_ENV_SSM.POSTGRES_DB_USER.name)[0])}/${lower(var.ADMIN_BACKEND_ENV_SSM.POSTGRES_DB_USER.name)}",
      description : var.ADMIN_BACKEND_ENV_SSM.POSTGRES_DB_USER.description,
      type : var.ADMIN_BACKEND_ENV_SSM.POSTGRES_DB_USER.type
      value : var.ADMIN_BACKEND_ENV_SSM.POSTGRES_DB_USER.value
    },
    (var.ADMIN_BACKEND_ENV_SSM.POSTGRES_DB_PASSWORD.name) : {
      name : "/${var.PROJECT_NAME}/${var.ENV}/${var.PROJECT_SERVICES.BACKEND_ADMIN}/${lower(split("_", var.ADMIN_BACKEND_ENV_SSM.POSTGRES_DB_PASSWORD.name)[0])}/${lower(var.ADMIN_BACKEND_ENV_SSM.POSTGRES_DB_PASSWORD.name)}",
      description : var.ADMIN_BACKEND_ENV_SSM.POSTGRES_DB_PASSWORD.description,
      type : var.ADMIN_BACKEND_ENV_SSM.POSTGRES_DB_PASSWORD.type
      value : var.ADMIN_BACKEND_ENV_SSM.POSTGRES_DB_PASSWORD.value
    },
    (var.ADMIN_BACKEND_ENV_SSM.COMMON_ADMIN_API_SECRET.name) : {
      name : "/${var.PROJECT_NAME}/${var.ENV}/${var.PROJECT_SERVICES.BACKEND_ADMIN}/${lower(split("_", var.ADMIN_BACKEND_ENV_SSM.COMMON_ADMIN_API_SECRET.name)[0])}/${lower(var.ADMIN_BACKEND_ENV_SSM.COMMON_ADMIN_API_SECRET.name)}",
      description : var.ADMIN_BACKEND_ENV_SSM.COMMON_ADMIN_API_SECRET.description,
      type : var.ADMIN_BACKEND_ENV_SSM.COMMON_ADMIN_API_SECRET.type
      value : var.ADMIN_BACKEND_ENV_SSM.COMMON_ADMIN_API_SECRET.value
    },
    (var.ADMIN_BACKEND_ENV_SSM.ENDPOINT_RPC.name) : {
      name : "/${var.PROJECT_NAME}/${var.ENV}/${var.PROJECT_SERVICES.BACKEND_ADMIN}/${lower(split("_", var.ADMIN_BACKEND_ENV_SSM.ENDPOINT_RPC.name)[0])}/${lower(var.ADMIN_BACKEND_ENV_SSM.ENDPOINT_RPC.name)}",
      description : var.ADMIN_BACKEND_ENV_SSM.ENDPOINT_RPC.description,
      type : var.ADMIN_BACKEND_ENV_SSM.ENDPOINT_RPC.type
      value : var.ADMIN_BACKEND_ENV_SSM.ENDPOINT_RPC.value
    },
    (var.ADMIN_BACKEND_ENV_SSM.JWT_DCARBON_ACCESS_TOKEN_SECRET.name) : {
      name : "/${var.PROJECT_NAME}/${var.ENV}/${var.PROJECT_SERVICES.BACKEND_ADMIN}/${lower(split("_", var.ADMIN_BACKEND_ENV_SSM.JWT_DCARBON_ACCESS_TOKEN_SECRET.name)[0])}/${lower(var.ADMIN_BACKEND_ENV_SSM.JWT_DCARBON_ACCESS_TOKEN_SECRET.name)}",
      description : var.ADMIN_BACKEND_ENV_SSM.JWT_DCARBON_ACCESS_TOKEN_SECRET.description,
      type : var.ADMIN_BACKEND_ENV_SSM.JWT_DCARBON_ACCESS_TOKEN_SECRET.type
      value : var.ADMIN_BACKEND_ENV_SSM.JWT_DCARBON_ACCESS_TOKEN_SECRET.value
    },
    (var.ADMIN_BACKEND_ENV_SSM.COMMON_PYTH_TOKEN_PRICE.name) : {
      name : "/${var.PROJECT_NAME}/${var.ENV}/${var.PROJECT_SERVICES.BACKEND_ADMIN}/${lower(split("_", var.ADMIN_BACKEND_ENV_SSM.COMMON_PYTH_TOKEN_PRICE.name)[0])}/${lower(var.ADMIN_BACKEND_ENV_SSM.COMMON_PYTH_TOKEN_PRICE.name)}",
      description : var.ADMIN_BACKEND_ENV_SSM.COMMON_PYTH_TOKEN_PRICE.description,
      type : var.ADMIN_BACKEND_ENV_SSM.COMMON_PYTH_TOKEN_PRICE.type
      value : var.ADMIN_BACKEND_ENV_SSM.COMMON_PYTH_TOKEN_PRICE.value
    },
  }
  TAGS = local.common-tags
}