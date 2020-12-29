//GUI
/*  
    vs_1_1
    dcl_position v0
    dcl_normal v1
    dcl_texcoord v3
    dcl_tangent v4
    dcl_tangent1 v5
    dcl_texcoord1 v6
    m4x4 oPos, v0, c10
    mul oT0.xy, v3, c16
    mov oD0, v4 */

uniform float4x4 ModelViewMatrix : register(c10); //x4
float4 diffuseColor : register(c16); //Kolor zaznaczenia

struct VS_INPUT
{
    float4 vPosition : POSITION;
    float4 vNormal : NORMAL0;
	float4 vNormal1 : NORMAL1;
    float2 vTex0 : TEXCOORD0;
	float4 vTangent: TANGENT0;
	float4 vTangent1: TANGENT1;
	float2 vTex1 : TEXCOORD1;
};

struct VS_OUTPUT
{
    float4 vPosition : POSITION;
    float4 vDiffuse : COLOR0;
	float2 oT0 : TEXCOORD0;
};

VS_OUTPUT  main(VS_INPUT input) {
	VS_OUTPUT output;

	float4 position = mul(input.vPosition, ModelViewMatrix);
    output.vPosition = position;

    output.oT0.xy = input.vTex0 * diffuseColor;
	
	output.vDiffuse = input.vTangent;
	
	return output;
}