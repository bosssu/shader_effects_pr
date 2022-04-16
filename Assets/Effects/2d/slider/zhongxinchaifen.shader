Shader "Unlit/zhongxinchaifen"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Blend("Blend",Range(0,1)) = 0
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
            float _Blend;

            v2f vert (appdata v)
            {
                v2f o = (v2f)0;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 newuv = i.uv;
                if(i.uv.x > 0.5 && i.uv.y > 0.5)
                {
                    newuv -= _Blend;
                }
                else if(i.uv.x > 0.5 && i.uv.y <= 0.5)
                {
                    newuv.x -= _Blend;
                    newuv.y += _Blend;
                }
                else if(i.uv.x <= 0.5 && i.uv.y <= 0.5)
                {
                    newuv.x += _Blend;
                    newuv.y += _Blend;
                }
                else if(i.uv.x <= 0.5 && i.uv.y > 0.5)
                {
                    newuv.x += _Blend;
                    newuv.y -= _Blend;
                }
                fixed4 col = tex2D(_MainTex,newuv);
                col.a = step(_Blend,abs(i.uv.x-0.5)) * step(_Blend,abs(i.uv.y-0.5));
                
                return col;
            }
            ENDCG
        }
    }
}
