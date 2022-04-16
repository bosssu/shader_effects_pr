Shader "Unlit/3dbillboard"
{
    Properties
    {
        _tex1 ("Tex1", 2D) = "white" {}
        _tex2 ("Tex2", 2D) = "white" {}
        _Width("Width",float) = 0.5
        _Progress("Progress",Range(0,1)) = 0
        _ShadowStrength("Shadow",  Range(0,2)) = 1.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "PreviewType"="Plane"}
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _tex1,_tex2;
            float4 _tex1_ST;
            float _Width,_Progress,_ShadowStrength;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _tex1);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float	posmod= fmod(i.uv.x,_Width);
                fixed2	uvA=fixed2(i.uv.x+(posmod-_Width)* _Progress/(1-_Progress), i.uv.y);
			    fixed2	uvB=fixed2(i.uv.x+(1-_Progress)*posmod /_Progress, i.uv.y);

                fixed4 col = tex2D(_tex1, uvA);
                fixed4 col2 = tex2D(_tex2, uvB);

                fixed4 color;
                
                if(posmod/_Width>_Progress){
                        
                        color=col;
                }else{
                        
                        color=col2;
                }

                return color;
            }
            ENDCG
        }
    }
}
