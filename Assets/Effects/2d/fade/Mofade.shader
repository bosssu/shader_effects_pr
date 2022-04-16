Shader "Unlit/Mofade"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Ramp("Ramp",2D) = "white"{}
        _Blend("Blend",Range(0,1.1)) = 0
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
                float4 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex,_Ramp;
            float4 _MainTex_ST,_Ramp_ST;
            float _Blend;

            v2f vert (appdata v)
            {
                v2f o = (v2f)0;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv.xy = v.uv;
                o.uv.zw = v.uv.xy * _Ramp_ST.xy + _Ramp_ST.zw;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {

                fixed4 col = tex2D(_MainTex,i.uv.xy);
                float f = tex2D(_Ramp,i.uv.zw).r;
                col.a = smoothstep(0,0.1,_Blend - f);                
                return col;
            }
            ENDCG
        }
    }
}
