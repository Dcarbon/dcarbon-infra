module "ssm-po-backend" {
  source               = "../modules/ssm"
  PROJECT_NAME         = var.PROJECT_NAME
  ENV                  = var.ENV
  PROJECT_SERVICE_TYPE = var.PROJECT_SERVICES.BACKEND_PO
  ENV_LIST = {
    (var.PO_BACKEND_ENV_SSM.JWT_ACCESS_TOKEN_SECRET.name) : {
      name : "/${var.PROJECT_NAME}/${var.ENV}/${var.PROJECT_SERVICES.BACKEND_PO}/${lower(split("_", var.PO_BACKEND_ENV_SSM.JWT_ACCESS_TOKEN_SECRET.name)[0])}/${lower(var.PO_BACKEND_ENV_SSM.JWT_ACCESS_TOKEN_SECRET.name)}",
      description : var.PO_BACKEND_ENV_SSM.JWT_ACCESS_TOKEN_SECRET.description,
      type : var.PO_BACKEND_ENV_SSM.JWT_ACCESS_TOKEN_SECRET.type
      value : var.PO_BACKEND_ENV_SSM.JWT_ACCESS_TOKEN_SECRET.value
    },
    (var.PO_BACKEND_ENV_SSM.JWT_REFRESH_TOKEN_SECRET.name) : {
      name : "/${var.PROJECT_NAME}/${var.ENV}/${var.PROJECT_SERVICES.BACKEND_PO}/${lower(split("_", var.PO_BACKEND_ENV_SSM.JWT_REFRESH_TOKEN_SECRET.name)[0])}/${lower(var.PO_BACKEND_ENV_SSM.JWT_REFRESH_TOKEN_SECRET.name)}",
      description : var.PO_BACKEND_ENV_SSM.JWT_REFRESH_TOKEN_SECRET.description,
      type : var.PO_BACKEND_ENV_SSM.JWT_REFRESH_TOKEN_SECRET.type
      value : var.PO_BACKEND_ENV_SSM.JWT_REFRESH_TOKEN_SECRET.value
    },
    (var.PO_BACKEND_ENV_SSM.POSTGRES_DB_HOST.name) : {
      name : "/${var.PROJECT_NAME}/${var.ENV}/${var.PROJECT_SERVICES.BACKEND_PO}/${lower(split("_", var.PO_BACKEND_ENV_SSM.POSTGRES_DB_HOST.name)[0])}/${lower(var.PO_BACKEND_ENV_SSM.POSTGRES_DB_HOST.name)}",
      description : var.PO_BACKEND_ENV_SSM.POSTGRES_DB_HOST.description,
      type : var.PO_BACKEND_ENV_SSM.POSTGRES_DB_HOST.type
      value : var.PO_BACKEND_ENV_SSM.POSTGRES_DB_HOST.value
    },
    (var.PO_BACKEND_ENV_SSM.POSTGRES_DB_NAME.name) : {
      name : "/${var.PROJECT_NAME}/${var.ENV}/${var.PROJECT_SERVICES.BACKEND_PO}/${lower(split("_", var.PO_BACKEND_ENV_SSM.POSTGRES_DB_NAME.name)[0])}/${lower(var.PO_BACKEND_ENV_SSM.POSTGRES_DB_NAME.name)}",
      description : var.PO_BACKEND_ENV_SSM.POSTGRES_DB_NAME.description,
      type : var.PO_BACKEND_ENV_SSM.POSTGRES_DB_NAME.type
      value : var.PO_BACKEND_ENV_SSM.POSTGRES_DB_NAME.value
    },
    (var.PO_BACKEND_ENV_SSM.POSTGRES_DB_USER.name) : {
      name : "/${var.PROJECT_NAME}/${var.ENV}/${var.PROJECT_SERVICES.BACKEND_PO}/${lower(split("_", var.PO_BACKEND_ENV_SSM.POSTGRES_DB_USER.name)[0])}/${lower(var.PO_BACKEND_ENV_SSM.POSTGRES_DB_USER.name)}",
      description : var.PO_BACKEND_ENV_SSM.POSTGRES_DB_USER.description,
      type : var.PO_BACKEND_ENV_SSM.POSTGRES_DB_USER.type
      value : var.PO_BACKEND_ENV_SSM.POSTGRES_DB_USER.value
    },
    (var.PO_BACKEND_ENV_SSM.POSTGRES_DB_PASSWORD.name) : {
      name : "/${var.PROJECT_NAME}/${var.ENV}/${var.PROJECT_SERVICES.BACKEND_PO}/${lower(split("_", var.PO_BACKEND_ENV_SSM.POSTGRES_DB_PASSWORD.name)[0])}/${lower(var.PO_BACKEND_ENV_SSM.POSTGRES_DB_PASSWORD.name)}",
      description : var.PO_BACKEND_ENV_SSM.POSTGRES_DB_PASSWORD.description,
      type : var.PO_BACKEND_ENV_SSM.POSTGRES_DB_PASSWORD.type
      value : var.PO_BACKEND_ENV_SSM.POSTGRES_DB_PASSWORD.value
    },
    (var.PO_BACKEND_ENV_SSM.COMMON_ADMIN_API_SECRET.name) : {
      name : "/${var.PROJECT_NAME}/${var.ENV}/${var.PROJECT_SERVICES.BACKEND_PO}/${lower(split("_", var.PO_BACKEND_ENV_SSM.COMMON_ADMIN_API_SECRET.name)[0])}/${lower(var.PO_BACKEND_ENV_SSM.COMMON_ADMIN_API_SECRET.name)}",
      description : var.PO_BACKEND_ENV_SSM.COMMON_ADMIN_API_SECRET.description,
      type : var.PO_BACKEND_ENV_SSM.COMMON_ADMIN_API_SECRET.type
      value : var.PO_BACKEND_ENV_SSM.COMMON_ADMIN_API_SECRET.value
    }
  }
  TAGS = local.common-tags
}