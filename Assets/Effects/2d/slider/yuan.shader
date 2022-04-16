Shader "Unlit/yuan"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Blend("Blend",Range(0,2)) = 0
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
                fixed4 col = tex2D(_MainTex,i.uv);
                float radio = _ScreenParams.x / _ScreenParams.y;
                float2 newuv = (i.uv-0.5) * float2(radio,1);
                float dis = length(newuv);
                float f = fwidth(i.uv * 6);
                col.a = smoothstep(_Blend,_Blend-f,dis);
                return col;
            }
            ENDCG
        }
    }
}
