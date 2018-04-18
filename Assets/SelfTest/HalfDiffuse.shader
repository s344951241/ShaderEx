Shader "Unlit/HalfDiffuse"
{
	Properties
	{
		_Diffuse("Diffuse",Color) = (1,1,1,1)
	}

	SubShader
	{
		Pass{
			Tags{"LightMode"="ForwardBase"}

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "Lighting.cginc"

			fixed4 _Diffuse;

			struct a2v{
				float4 vertex:POSITION;
				float3 normal:NORMAL;
			};

			struct v2f{
				float4 pos:SV_POSITION;
				float3 worldNormal:TEXCOORD0;
			};

			v2f vert(a2v v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.worldNormal = mul(unity_ObjectToWorld,v.normal);
				return o;
			}

			fixed4 frag(v2f i):SV_Target
			{
				float3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

				float3 diffuse = _LightColor0.rgb*_Diffuse.rgb*(0.5*dot(normalize(i.worldNormal),normalize(_WorldSpaceLightPos0.xyz))+0.5);

				return fixed4(ambient+diffuse,1);

			}

			ENDCG
		}
	}

	FallBack "Diffuse"
}
