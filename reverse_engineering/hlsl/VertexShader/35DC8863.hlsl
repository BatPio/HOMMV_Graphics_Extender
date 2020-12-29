 //trees shadows
 /*   vs_1_1
    dcl_position v0
    dcl_normal v1
    dcl_texcoord v3
    dcl_tangent v4
    dcl_tangent1 v5
    dcl_texcoord1 v6
    dp4 r0.y, v0, c25
    dp4 r0.x, v0, c26
    mad oPos.xy, r0.xyyy, c27.xyyy, c27.zwww

#line 11
    dp4 oPos.z, v0, c17
    mov oPos.w, c1
    dp4 oD0.w, v0, c24
    mov oD0.xyz, c1
    mul oT0.xy, v3, c6.x

// approximately 8 instruction slots used
 */

 uniform float4x4 ModelViewMatrix : register(c10); //x4
float4 diffuseColor : register(c16); //Kolor zaznaczenia
float4 p25 : register(c25);
float4 p26 : register(c26);
float4 p27 : register(c27);
float4 p17 : register(c17);
float4 p1 : register(c1);
float4 p6 : register(c6);
float4 p24 : register(c24);

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
    float2 posFactor;
    posFactor.x = dot(input.vPosition, p26);
    posFactor.y = dot(input.vPosition, p25);
    output.vPosition.xy = mad(posFactor.xyyy, p27.xyyy, p27.zwww);
    output.vPosition.z = dot(input.vPosition , p17);
    output.vPosition.w = p1;

	output.vDiffuse.xyz = p1;
    output.vDiffuse.w = dot(input.vPosition , p24);

	output.oT0.xy = input.vTex0 * p6.x;
	return output;
}