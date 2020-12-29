//terrain
/*
vs_3_0
    dcl_position v0
    dcl_normal v1
    dcl_normal1 v2
    dcl_texcoord v3
    dcl_tangent v4
    dcl_tangent1 v5
    dcl_position o0
    dcl_fog o1.x
    dcl_texcoord o2.xy
    dcl_texcoord1 o3.xy
    dcl_texcoord2 o4
    dcl_color o5
    dcl_color1 o6
    dp4 o0.x, v0, c10
    dp4 o0.y, v0, c11
    dp4 o0.z, v0, c12
    dp4 r0.y, v0, c25
    dp4 r0.x, v0, c26
    mad o3.xy, r0, c27, c27.zwzw
    mul r0.x, c30.y, v4.w
    mad r0.x, v5.w, c30.x, r0.x
    mul r0.yzw, r0.x, c29.xxyz
    mul o5.xyz, r0.yzww, v4
    mul o6.xyz, r0.yzww, v5
    mul o5.w, c29.w, v1.w
    dp4 o4, v0, c23
    mad r0.y, c19.z, v0.z, c19.w
    dp4 r0.z, v0, c13
    mad r0.w, c19.x, r0.z, c19.y
    mov o0.w, r0.z
    min r0.y, r0.y, r0.w
    max r0.y, r0.y, c0.x
    add r0.y, r0.y, c1.x
    add o1.x, -r0.x, r0.y
    mov r0.xy, c38
    mad r0.xy, v3.x, r0, c39
    mad o2.xy, v3.y, c38.zwzw, r0
    mov o6.w, v2.w
*/

//sampler samp0: register(s0);
//sampler samp1: register(s1);

float4 p6 : register(c6); //x1
uniform float4x4 ModelViewMatrix : register(c10); //x4
float4 p0 : register(c0);
float4 p1 : register(c1);
float4 p2 : register(c2);
float4 diffuseColor : register(c16); //Kolor zaznaczenia

//(fog_end - camera)/(fog_end - fog_start)
// fogFactors.x = -1/(fog_end - fog_start)
// fogFactors.y = fog_end/(fog_end - fog_start)
// fogFactors.z = -1/(fog_end - fog_start)
// fogFactors.w = fog_end/(fog_end - fog_start)
float4 fogFactors : register(c19); //x2
float4 p23 : register(c23); //x1
float4 p24 : register(c24);
float4 p25 : register(c25); //x1
float4 p26 : register(c26); //x1
float4 p27 : register(c27); //x1
float4 p29 : register(c29); //x1
float4 p30 : register(c30); //x1
float4 p31 : register(c31); //x1
float4 p32 : register(c32); //x1
float4 p34 : register(c34);
float4 p35 : register(c35);
float4 p36 : register(c36);
float4 p38 : register(c38); //x1
float4 p39 : register(c39); //x1
//c9 x1
//c14 x1
//c15 x1
//c21 x1
//c31 x1
//c24 x1
//c35 x1

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
	float fog : FOG;
	
	float2 oT0 : TEXCOORD0; //tekstura podstawowa
	//Light tangent
	float2 oT1: TEXCOORD1; // s(t1).w -> mapa cieni
	//View tangent
	float4 oT2: TEXCOORD2; // z -> wysoko�� (Y)
	
	float4 vDiffuse : COLOR0; // xyz diff lifght, w mieszanie tekstur
	//Fog of war, alpha
	float4 color : COLOR1; //xyz diff light dla cienia
};

VS_OUTPUT  main(VS_INPUT input) {
	VS_OUTPUT output;
	float4 position = mul(input.vPosition, ModelViewMatrix); 
    output.vPosition = position;

	//(Fog_end - camera)/(Fog_end - fog_start)
    float dFog = fogFactors.x * position.w + fogFactors.y;
    float hFog = fogFactors.z * input.vPosition.z + fogFactors.w;
    float fog = max(min(dFog, hFog), p0.x);
	
	float fogOfWar = (input.vTangent1.w * p30.x) + (input.vTangent.w * p30.y);//Fog of war gradient
	/*if(fogOfWar < 0.5) {
		float4 flatPoint = {input.vPosition.x, input.vPosition.y, 0.0f, input.vPosition.w};
		output.vPosition=  mul(flatPoint, ModelViewMatrix);

	}*/
	float4 temp = {1.0f, 1.0f, 1.0f, 1.0f};
	
	
	float2 colorThing;
	colorThing.y = dot(input.vPosition, p25);
	colorThing.x = dot(input.vPosition, p26);
	output.oT1 = colorThing.xy * p27.xy + p27.zw;
	//output.oT1 = temp;
	
	output.vDiffuse.xyz = input.vTangent * (fogOfWar * p29);
	output.vDiffuse.w = input.vNormal.w * p29.w;
	
	output.color.xyz = input.vTangent1 * (fogOfWar * p29);
	output.color.w = input.vNormal1.w; //nieuzywane
	
	output.oT2 = dot(input.vPosition, p23);
	
	fog = fog + p1.x;
	output.fog = fog - fogOfWar; //0 = max fog
	
	output.oT0 = mad(input.vTex0.y, p38.zw , mad (input.vTex0.x , p38.xy , p39.xy));//Tekstura podstawowa
	return output;
}