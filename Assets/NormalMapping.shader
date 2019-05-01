Shader "MyShaders/NormalMapping"
{
	Properties
	{
		_NormalMap("Texture normalMap", 2D) = "white" {}
	}
		SubShader
	{
		Tags{ "RenderType" = "Opaque" "LightMode" = "ForwardBase" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
				float3 tangent : TANGENT;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
				float3 tangent : TANGENT;
				float3 bitangent : BITANGENT;
			};

			sampler2D _NormalMap;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;

				o.normal = normalize(mul(v.normal, unity_WorldToObject));
				o.tangent = normalize(mul(v.tangent, unity_WorldToObject));
				o.bitangent = cross(o.tangent, o.normal);

				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				float3 tangentSpace_normal = tex2D(_NormalMap, i.uv) * 2 - 1;

				float3 worldSpace_normal =
					i.tangent * tangentSpace_normal.r +
					i.bitangent * tangentSpace_normal.g + 
					i.normal * tangentSpace_normal.b ;
					
				return dot(worldSpace_normal, _WorldSpaceLightPos0);
			}
			ENDCG
		}
	}
}
