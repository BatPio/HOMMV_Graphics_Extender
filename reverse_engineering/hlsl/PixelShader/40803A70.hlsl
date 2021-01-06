sampler samp0: register(s0);

float4 main(float2 t0 : TEXCOORD0, float4 color : COLOR0) : COLOR {
	return tex2D(samp0, t0) + color;
}