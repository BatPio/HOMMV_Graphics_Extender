 /*   vs_1_1
    dcl_position v0
    dcl_normal v1
    dcl_texcoord v3
    dcl_tangent v4
    dcl_tangent1 v5
    dcl_texcoord1 v6
    m4x4 oPos, v0, c10
    mul r0.xy, v3, c16
    mov oT0.xy, r0

#line 11
    mad oT1.xy, c17.xyyy, r0.xyyy, c17.zwww
    mov oD0, v4

 */

uniform float4x4 ModelViewMatrix : register(c10); //x4
float4 diffuseColor : register(c16); //Kolor zaznaczenia
float4 p17 : register(c17);

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
    float2 oT1 : TEXCOORD1;
};

VS_OUTPUT  main(VS_INPUT input) {
	VS_OUTPUT output;
	float4 position = mul(input.vPosition, ModelViewMatrix); 
    output.vPosition = position;

    float2 factor =  input.vTex0 * diffuseColor;
    output.oT0.xy = factor;

    output.oT1.xy = mad(p17.xyyy, factor.xyyy , p17.zwww);

    output.vDiffuse = input.vTangent;

	return output;
}