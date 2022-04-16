Shader "Unlit/clock"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Blend("Blend",Range(0,6.5)) = 0
        _Width("Width",float) = 10
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
            float _Blend,_Width;

            v2f vert (appdata v)
            {
                v2f o = (v2f)0;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {

                float2 newuv = floor(i.uv * _Width) / _Width;
                fixed4 col = tex2D(_MainTex,i.uv);

                float f = acos(dot(float2(1,0),normalize(newuv-0.5)));
                if(newuv.y - 0.5 > 0)
                {
                    f = 6.28 - f;
                }

                if(f < _Blend)
                {
                    col.a = 0;
                }
                else
                {
                    col.a = 1;
                }
                return col;
            }
            ENDCG
        }
    }
}
