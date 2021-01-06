/*
    ps_1_1
    tex t0
    mov r0, t0
*/
sampler samp: register(s0);

float4 main( float2 t0 : TEXCOORD0) : COLOR {
	return tex2D(samp, t0);
}