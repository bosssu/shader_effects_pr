Shader "Unlit/randomErase"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Width("Width",float) = 6
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
            float _Blend,_Width;

            v2f vert (appdata v)
            {
                v2f o = (v2f)0;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv.xy = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                //grid效果
                fixed4 col = tex2D(_MainTex,i.uv.xy);
                float radio = _ScreenParams.x / _ScreenParams.y;
                float2 newuv = floor(i.uv * float2(radio,1) * _Width) / _Width;
                
                //在渐变区域形成随机块状的效果
                float sd = smoothstep(_Blend-0.3,_Blend,newuv.x);
                if(sd > 0 && sd < 1)
                {
                    float s = tex2D(_MainTex,newuv).r;
                    col.a = step(0,sd-s);
                }
                else{
                    col.a = sd;
                }
                return col;
            }
            ENDCG
        }
    }
}
