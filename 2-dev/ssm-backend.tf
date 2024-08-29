module "ssm-backend" {
  source               = "../modules/ssm"
  PROJECT_NAME         = var.PROJECT_NAME
  ENV                  = var.ENV
  PROJECT_SERVICE_TYPE = var.PROJECT_SERVICES.BACKEND
  ENV_LIST = {
    (var.BACKEND_ENV_SSM.POSTGRES_DB_HOST.name) : {
      name : "/${var.PROJECT_NAME}/${var.ENV}/${var.PROJECT_SERVICES.BACKEND}/${lower(split("_", var.BACKEND_ENV_SSM.POSTGRES_DB_HOST.name)[0])}/${lower(var.BACKEND_ENV_SSM.POSTGRES_DB_HOST.name)}",
      description : var.BACKEND_ENV_SSM.POSTGRES_DB_HOST.description,
      type : var.BACKEND_ENV_SSM.POSTGRES_DB_HOST.type
      value : var.BACKEND_ENV_SSM.POSTGRES_DB_HOST.value
    },
    (var.BACKEND_ENV_SSM.POSTGRES_DB_NAME.name) : {
      name : "/${var.PROJECT_NAME}/${var.ENV}/${var.PROJECT_SERVICES.BACKEND}/${lower(split("_", var.BACKEND_ENV_SSM.POSTGRES_DB_NAME.name)[0])}/${lower(var.BACKEND_ENV_SSM.POSTGRES_DB_NAME.name)}",
      description : var.BACKEND_ENV_SSM.POSTGRES_DB_NAME.description,
      type : var.BACKEND_ENV_SSM.POSTGRES_DB_NAME.type
      value : var.BACKEND_ENV_SSM.POSTGRES_DB_NAME.value
    },
    (var.BACKEND_ENV_SSM.POSTGRES_DB_USER.name) : {
      name : "/${var.PROJECT_NAME}/${var.ENV}/${var.PROJECT_SERVICES.BACKEND}/${lower(split("_", var.BACKEND_ENV_SSM.POSTGRES_DB_USER.name)[0])}/${lower(var.BACKEND_ENV_SSM.POSTGRES_DB_USER.name)}",
      description : var.BACKEND_ENV_SSM.POSTGRES_DB_USER.description,
      type : var.BACKEND_ENV_SSM.POSTGRES_DB_USER.type
      value : var.BACKEND_ENV_SSM.POSTGRES_DB_USER.value
    },
    (var.BACKEND_ENV_SSM.POSTGRES_DB_PASSWORD.name) : {
      name : "/${var.PROJECT_NAME}/${var.ENV}/${var.PROJECT_SERVICES.BACKEND}/${lower(split("_", var.BACKEND_ENV_SSM.POSTGRES_DB_PASSWORD.name)[0])}/${lower(var.BACKEND_ENV_SSM.POSTGRES_DB_PASSWORD.name)}",
      description : var.BACKEND_ENV_SSM.POSTGRES_DB_PASSWORD.description,
      type : var.BACKEND_ENV_SSM.POSTGRES_DB_PASSWORD.type
      value : var.BACKEND_ENV_SSM.POSTGRES_DB_PASSWORD.value
    },
    (var.BACKEND_ENV_SSM.COMMON_ADMIN_API_SECRET.name) : {
      name : "/${var.PROJECT_NAME}/${var.ENV}/${var.PROJECT_SERVICES.BACKEND}/${lower(split("_", var.BACKEND_ENV_SSM.COMMON_ADMIN_API_SECRET.name)[0])}/${lower(var.BACKEND_ENV_SSM.COMMON_ADMIN_API_SECRET.name)}",
      description : var.BACKEND_ENV_SSM.COMMON_ADMIN_API_SECRET.description,
      type : var.BACKEND_ENV_SSM.COMMON_ADMIN_API_SECRET.type
      value : var.BACKEND_ENV_SSM.COMMON_ADMIN_API_SECRET.value
    },
    (var.BACKEND_ENV_SSM.ENDPOINT_RPC.name) : {
      name : "/${var.PROJECT_NAME}/${var.ENV}/${var.PROJECT_SERVICES.BACKEND}/${lower(split("_", var.BACKEND_ENV_SSM.ENDPOINT_RPC.name)[0])}/${lower(var.BACKEND_ENV_SSM.ENDPOINT_RPC.name)}",
      description : var.BACKEND_ENV_SSM.ENDPOINT_RPC.description,
      type : var.BACKEND_ENV_SSM.ENDPOINT_RPC.type
      value : var.BACKEND_ENV_SSM.ENDPOINT_RPC.value
    },
  }
  TAGS = local.common-tags
}