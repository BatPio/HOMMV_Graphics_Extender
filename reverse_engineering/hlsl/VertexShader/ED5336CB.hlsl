  //terrain tress, but not trees shadows
  /*
    vs_1_1
    dcl_position v0
    dcl_normal v1
    dcl_texcoord v3
    dcl_tangent v4
    dcl_tangent1 v5
    dcl_texcoord1 v6
    mov r3, v0
    mad r3.xy, v6.xyyy, c31.xyyy, r3.xyyy
    mad r3.xy, v6.xyyy, c31.zwww, r3.xyyy

#line 11
    m4x4 r2, r3, c10
    mov oPos, r2
    mad r4.x, r2.w, c19.x, c19.y
    mad r4.y, v0.z, c19.z, c19.w
    min r4.x, r4.x, r4.y
    max r0, r4.x, c0.x
    mad r1.xyz, v1, c3.x, c3.y
    mul r4.w, v4.w, c30.y //input.vTangent.w * p30.y
    mad r4.w, v5.w, c30.x, r4.w //mad(vTangent1, p30.x, (input.vTangent.w * p30.y))
    dp4 r8.x, v0, c25 /posa
    dp4 r8.y, v0, c26 /posb

#line 22
    mad r9.xy, r8.xyyy, r8.xyyy, c3.z pox * log(mad(pox,pox,p3.z))
    logp r10, r9.x
    mul r8.x, r8.x, r10.z
    logp r10, r9.y
    mul r8.y, r8.y, r10.z
    rsq r9.x, r9.x
    rsq r9.y, r9.y //rsqrt()
    mul r8.xy, r8.xyyy, r9.xyyy
    mad oT1.xy, r8.xyyy, c27.xyyy, c27.zwww
    dp3 r5.x, r1, c35
    mul r4.xyz, r4.w, c29 //float4 fator = mad(vTangent1, p30.x, (input.vTangent.w * p30.y)) * p29;

#line 33
    mul oD0.xyz, v4, r4
    mul oD0.w, v1.w, c29.w
    mul oD1.xyz, v5, r4
    sge r7.y, -r5.x, c35.w
    dp4 r7.x, v0, c24
    add oT2, r7.x, r7.y
    add r0.x, c1.x, r0.x
    add oFog, r0.x, -r4.w
    mov r3, c39.xyyy
    mad r2.xy, v3.x, c38.xyyy, r3.xyyy
    mad oT0.xy, v3.y, c38.zwww, r2.xyyy

// approximately 39 instruction slots used
 
*/
float4 p0 : register(c0);
float4 p1 : register(c1);
float4 p3 : register(c3);
uniform float4x4 ModelViewMatrix : register(c10); //x4
float4 diffuseColor : register(c16); //Kolor zaznaczenia
float4 fogFactors : register(c19); //x2
float4 p23 : register(c23);
float4 p24 : register(c24);
float4 p25 : register(c25);
float4 p26 : register(c26);
float4 p27 : register(c27);
float4 p29 : register(c29);
float4 p30 : register(c30); //fog
float4 p31 : register(c31); //wind
float4 p35 : register(c35); 
float4 p38 : register(c38);
float4 p39 : register(c39);

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
    float4 vDiffuse : COLOR0;
    float4 vDiffuse1 : COLOR1;
	float2 oT0 : TEXCOORD0;
    float2 oT1 : TEXCOORD1;
    float2 oT2 : TEXCOORD2;
};

VS_OUTPUT  main(VS_INPUT input) {
	VS_OUTPUT output;
    float4 red ={0.0f, 1.0f, 1.0f, 0.7f};
    float4 green ={0.0f, 0.0f, 1.0f, 0.7f};

    /*
    mov r3, v0
    mad r3.xy, v6.xyyy, c31.xyyy, r3.xyyy
    mad r3.xy, v6.xyyy, c31.zwww, r3.xyyy

#line 11
    m4x4 r2, r3, c10
    mov oPos, r2*/
    //float2 position = mad(input.vTex1.y, p31.zw, mad(input.vTex1.x, p31.xy, input.vPosition.xy));
    float4 positionInWind  = input.vPosition;
    positionInWind.xy = mad(input.vTex1, p31.zw, mad(input.vTex1, p31.xy, input.vPosition.xy));
    //position = mul( input.vPosition, ModelViewMatrix);
    output.vPosition = mul(positionInWind, ModelViewMatrix);

    	//(Fog_end - camera)/(Fog_end - fog_start)
    float dFog = fogFactors.x * output.vPosition.w + fogFactors.y;
    float hFog = fogFactors.z * input.vPosition.z + fogFactors.w;
    float fog = max(min(dFog, hFog), p0.x);

	float fogOfWar = (input.vTangent1.w * p30.x) + (input.vTangent.w * p30.y);//Fog of war gradient
    //float colorFactor1 = mad(input.vTangent1, p30.x, (input.vTangent.w * p30.y));
   // colorFactor1.xyz = colorFactor1.w * p29;

   	fog = fog + p1.x;
	output.fog = fog - fogOfWar; //0 = max fog

    output.vDiffuse.xyz = input.vTangent * fogOfWar * p29.xyz;
    output.vDiffuse.w = input.vNormal.w * p29.w;
    
    output.vDiffuse1.xyz = input.vTangent1 * fogOfWar * p29.xyz;
    output.vDiffuse1.w = 1.0f;

    output.oT0.xy = mad(input.vTex0.y, p38.zw, mad(input.vTex0.x, p38.xy, p39.xy));

    float3 factor1=mad(input.vNormal, p3.x, p3.y);
    output.oT2 = dot(input.vPosition, p24) + step(-dot(factor1,p35),p35.w) ;
    
    float2 posfactor1;
    posfactor1.x = dot(input.vPosition, p25);
    posfactor1.y = dot(input.vPosition, p26);
    float2 posfactor2 = mad(posfactor1,posfactor1, p3);
    posfactor1.x = posfactor1.x * log(posfactor2.x);
    posfactor1.y = posfactor1.y * log(posfactor2.y);
    posfactor2.x = rsqrt(posfactor2.x);
    posfactor2.y = rsqrt(posfactor2.y);

    output.oT1.xy = mad(posfactor1 * posfactor2, p27.xy, p27.zw);
    //output.oT2.xy = input.vTex1;
	
	//output.vDiffuse = input.vTangent;

	
	return output; 
}