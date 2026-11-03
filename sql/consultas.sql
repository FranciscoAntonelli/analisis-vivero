--¿Cuáles son los productos más vendidos?
select p.nombre, sum(dv.cantidad) as cantidad_vendida
from productos as p, detalle_ventas as dv
where p.id_producto = dv.id_producto
group by p.nombre
order by cantidad_vendida desc
limit 10;

-- ¿Qué productos generan mayor facturación?
select p.nombre, sum(dv.precio_venta * cantidad) as total_vendido
from productos as p, detalle_ventas as dv
where p.id_producto = dv.id_producto
group by p.nombre
order by total_vendido desc
limit 10;

--¿Cómo evolucionaron las ventas a lo largo del tiempo?
select extract(month from f.fecha) as mes, sum(v.total) as total_venta
from ventas v, fechas f
where v.id_fecha = f.id_fecha
group by mes
order by mes asc;


-- ¿Qué categorías concentran mayor volumen de ventas?
select c.nombre, sum(cantidad) as cantidad_vendida
from productos p, categorias c, detalle_ventas dv
where p.id_categoria = c.id_categoria 
and p.id_producto = dv.id_producto
group by c.nombre
order by cantidad_vendida desc;


--¿Qué productos presentan baja rotación?
select p.nombre, coalesce(sum(dv.cantidad), 0) as cantidad_vendida
from productos as p
left join detalle_ventas as dv
on p.id_producto = dv.id_producto
group by p.nombre
order by cantidad_vendida asc
limit 10;

-- como varia el stock de los productos?
select p.nombre as producto, f.fecha, s.cantidad as cantidad_disponible
from productos p, stocks s, fechas f
where s.id_fecha = f.id_fecha
and p.id_producto = s.id_producto
order by p.nombre, f.fecha asc

-- ¿Qué productos presentan riesgo de quedarse sin stock?
select p.nombre, s.cantidad as cantidad_disponible
from productos p, stocks s, fechas f
where p.id_producto = s.id_producto
and s.id_fecha = f.id_fecha
and f.fecha = 
(
    select max(f2.fecha)
    from fechas f2, stocks s2
    where f2.id_fecha = s2.id_fecha
    and s2.id_producto = p.id_producto
)
order by cantidad_disponible asc
limit 5;

-- ¿Existen períodos del año con mayores niveles de venta?
select extract(month from f.fecha) as mes,
       sum(v.total) as total_venta
from ventas v, fechas f
where v.id_fecha = f.id_fecha
group by mes
order by mes asc;

-- ¿Cómo se relacionan las ventas con los niveles de stock?
select v.anio, v.mes, v.nombre, v.cantidad_vendida, s.cantidad_stock
from (
	select extract(year from f.fecha) as anio, 
	extract(month from f.fecha) as mes, p.id_producto, p.nombre, 
	sum(dv.cantidad) as cantidad_vendida
	from productos p, detalle_ventas dv, ventas ve, fechas f
	where dv.id_producto = p.id_producto
	and ve.id_venta = dv.id_venta
	and f.id_fecha = ve.id_fecha
	group by anio, mes, p.id_producto
) v, (
	select extract(year from f.fecha) as anio,
	extract(month from f.fecha) as mes, s.id_producto, s.cantidad as cantidad_stock
	from stocks s, fechas f
	where f.id_fecha = s.id_fecha
	and f.fecha = (
		select max(f2.fecha) 
		from fechas f2, stocks s2
		where f2.id_fecha = s2.id_fecha
		and s2.id_producto = s.id_producto
		and extract(year from f2.fecha) = extract(year from f.fecha)
		and extract(month from f2.fecha) = extract(month from f.fecha)
	)
) s
where v.mes = s.mes
and v.anio = s.anio
and v.id_producto = s.id_producto
order by v.anio, v.mes, v.nombre asc;


-- ¿Qué productos presentan mejores resultados económicos?
select p.nombre, sum((dv.precio_venta - p.costo) * dv.cantidad) as ganancia
from productos p, detalle_ventas dv
where p.id_producto = dv.id_producto
group by p.nombre
order by ganancia desc
limit 10;

-- ¿Qué categorias presentan mejores resultados económicos?
select c.nombre, sum((dv.precio_venta - p.costo) * dv.cantidad) as ganancia
from productos p, categorias c, detalle_ventas dv
where p.id_producto = dv.id_producto
and p.id_categoria = c.id_categoria
group by c.nombre
order by ganancia desc
limit 10;
