<script lang="ts">
	import type { IProperty } from '@typings/type'
	import { REALTOR_GRADE, SHELLS } from '@store/stores'
	import { fly } from 'svelte/transition'

	export let id = 'property-card-1',
		property: IProperty = null,
		selectedProperty: IProperty = null

		console.log(property.extra_imgs[0] && property.extra_imgs[0].url,  $SHELLS[property.shell].imgs[0].url)
</script>

<div {id} class="property-card-wrapper group">
	<div class="w-full h-fit grid place-items-center relative">
		{#if property.extra_imgs[0] ? property.extra_imgs[0].url : $SHELLS[property.shell].imgs[0].url}
			<img
				src={property.extra_imgs[0]
					? property.extra_imgs[0].url
					: $SHELLS[property.shell].imgs[0].url}
				alt=""
			/>
		{:else}
			<!-- svelte-ignore a11y-img-redundant-alt -->
			<img
				src="images/property-card-img.png"
				alt="Default Property Card Image"
			/>
		{/if}

		<button
			class="invisible h-0 w-fit absolute px-[1vw] py-[0.5vw] group-hover:visible group-hover:h-fit card-hover-button"
			on:click={() => (selectedProperty = property)}
			in:fly={{ y: 10, duration: 250 }}
		>
			Ver Propriedade
		</button>
	</div>

	<div class="property-card-details">
		<p class="property-name">
			{property.street
				? property.street + ' - '
				: property.apartment
				? property.apartment + ' - '
				: ''}
			{property.property_id}
		</p>
		<p class="property-address">{property.region ? property.region : ''}</p>
		<p class="property-cost">R$ {property.price?.toLocaleString()}</p>
		<div class="property-details">
			{#if $REALTOR_GRADE >= 0 && property.for_sale}
				<div class="each-tile">
					<i class="fa-solid fa-dollar-sign" style="color: #63E6BE;"/>
					Á venda
				</div>
			{/if}

			<div class="each-tile">
				<i class="fas fa-image" />
				Fotos: {$SHELLS[property.shell]
					? $SHELLS[property.shell].imgs.length
					: 0}
			</div>

			<div class="each-tile">
				<i class="fas fa-house-chimney" />
				{property.shell}
			</div>

			<div class="each-tile">
				<i class="fas fa-truck-front" />
				Garagem: {property.garage_data
					? Object.keys(property.garage_data).length > 0
						? 'Sim'
						: 'Não'
					: 'Não'}
			</div>
		</div>
	</div>
</div>
