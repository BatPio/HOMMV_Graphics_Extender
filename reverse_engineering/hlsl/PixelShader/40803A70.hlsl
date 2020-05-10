sampler samp;

float4 main(float2 t0 : TEXCOORD0, float4 color : COLOR) : COLOR0 {
	return tex2D(samp, t0) + color;
}