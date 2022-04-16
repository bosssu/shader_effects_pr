Shader "Unlit/huadongqiefen"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Blend("Blend",Range(0,1)) = 0
        _Height("Height",float) = 6
        _Rotate("Rotate",float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "PreviewType"="Plane" "Queue"="Transparent"}
        Blend SrcAlpha OneMinusSrcAlpha
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma shader_feature IsX

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Blend,_Height,_Rotate;

            float2 rotateUV(float2 srcUV,float rad)
            {
                return mul(srcUV,float2x2(cos(rad),-sin(rad),sin(rad),cos(rad)));
            }

            v2f vert (appdata v)
            {
                v2f o = (v2f)0;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {

                float radio = _ScreenParams.y / _ScreenParams.x;
                i.uv.y *= radio;
                float2 center = float2(0.5,0.5 * radio);
                i.uv = center + rotateUV(i.uv - center,_Rotate);

                float2 newuv1 = i.uv;
                float2 newuv2 = i.uv;
                float2 newuv = i.uv;
                float xx = step(0,frac(newuv.y * _Height) * 2 - 1);
                newuv1.x -= _Blend;
                newuv2.x += _Blend;
                
                fixed4 col = tex2D(_MainTex,newuv1);
                col *= xx * step(_Blend,i.uv.x);
                fixed4 col2 = tex2D(_MainTex,newuv2);
                col2 *= (1 - xx) * step(_Blend,1-i.uv.x);
                
                return col2 + col;
            }
            ENDCG
        }
    }
}
