resource "aws_api_gateway_rest_api" "panda" {
  name = "panda"
}

resource "aws_api_gateway_resource" "panda" {
  parent_id   = aws_api_gateway_rest_api.panda.root_resource_id
  path_part   = "panda"
  rest_api_id = aws_api_gateway_rest_api.panda.id
}

resource "aws_api_gateway_method" "panda" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.panda.id
  rest_api_id   = aws_api_gateway_rest_api.panda.id
}

resource "aws_api_gateway_integration" "panda" {
  http_method = aws_api_gateway_method.panda.http_method
  resource_id = aws_api_gateway_resource.panda.id
  rest_api_id = aws_api_gateway_rest_api.panda.id
  type        = "MOCK"
}

resource "aws_api_gateway_method" "panda1" {
  rest_api_id          = aws_api_gateway_rest_api.panda.id
  resource_id          = aws_api_gateway_resource.panda.id
  http_method          = "POST"
  authorization        = "NONE"
}


resource "aws_api_gateway_integration" "integration" {
  
  rest_api_id             = aws_api_gateway_rest_api.panda.id
  resource_id             = aws_api_gateway_resource.panda.id
  http_method             = aws_api_gateway_method.panda1.http_method
  type                    = "MOCK"
  
  request_parameters = {
    "integration.request.header.X-Authorization" = "'static'"
  }

  # Transforms the incoming XML request to JSON
  request_templates = {
    "application/xml" = <<EOF
{
   
   "statusCode" : 200,
   "message" : "Healthy"
}
EOF
  }
}




resource "aws_api_gateway_deployment" "panda" {
  rest_api_id = aws_api_gateway_rest_api.panda.id

  triggers = {
   
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.panda.id,
      aws_api_gateway_method.panda.id,
      aws_api_gateway_integration.panda.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "panda" {
  deployment_id = aws_api_gateway_deployment.panda.id
  rest_api_id   = aws_api_gateway_rest_api.panda.id
  stage_name    = "panda"
}

output "rest_api_id" {
  value = aws_api_gateway_rest_api.panda.id
}

output "resource_id" {
  value = aws_api_gateway_resource.panda.id
}