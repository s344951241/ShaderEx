Shader "Unlit/Alpha"
{	
	Properties
	{
		_Color("Color Tint",Color)=(1,1,1,1)
		_AlphaScale("AlphaScale",Range(0,1))=1
	}

	SubShader
	{
		Tags{"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"= "Transparent"}
		Pass{
			Tags{"LightMode"="ForwardBase"}

			Cull Front
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "Lighting.cginc"

			fixed4 _Color;
			fixed _AlphaScale;

			struct a2v{
				float4 vertex:POSITION;
				float3 normal:NORMAL;
			};

			struct v2f{
				float4 pos:SV_POSITION;
				float3 worldNormal:NORMAL;
				float3 worldPos:TEXCOORD0;
			};


			v2f vert(a2v v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.worldNormal = mul(unity_ObjectToWorld,v.normal);
				o.worldPos = mul(unity_ObjectToWorld,v.vertex);
				return o;
			}

			fixed4 frag(v2f i):SV_Target
			{
				fixed3 worldNormal = normalize(i.worldNormal);
				fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));

				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

				fixed3 diffuse = _LightColor0.rgb*_Color.rgb*(0.5*dot(worldNormal,worldLightDir)+0.5);

				return fixed4(ambient+diffuse,_AlphaScale);

			}


			ENDCG
		}

		Pass{
			Tags{"LightMode"="ForwardBase"}

			Cull Back
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "Lighting.cginc"

			fixed4 _Color;
			fixed _AlphaScale;

			struct a2v{
				float4 vertex:POSITION;
				float3 normal:NORMAL;
			};

			struct v2f{
				float4 pos:SV_POSITION;
				float3 worldNormal:NORMAL;
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
				fixed3 worldNormal = normalize(i.worldNormal);
				fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);

				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz*_Color.rgb;

				fixed3 diffuse = _LightColor0.rgb*_Color.rgb*(0.5*dot(worldNormal,worldLightDir)+0.5);

				return fixed4(ambient+diffuse,_AlphaScale);

			}


			ENDCG
		}
	}
	//FallBack "Diffuse"
}
