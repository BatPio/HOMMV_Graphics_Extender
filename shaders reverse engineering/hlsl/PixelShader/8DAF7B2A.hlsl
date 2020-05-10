sampler samp;

float4 main( float2 t0 : TEXCOORD0) : COLOR0 {
	return tex2D(samp, t0).w;
}