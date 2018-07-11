view: products {
  sql_table_name: thelook.products ;;

  dimension: id {
    description: "Primary Key"
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: brand {
    description: "Brand of Items"
    type: string
    sql: ${TABLE}.brand ;;
  }

  dimension: category {
    description: "Item Category"
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: department {
    description: "Department"
    type: string
    sql: ${TABLE}.department ;;
    drill_fields: [id, rank, sku]
  }

  dimension: item_name {
    description: "Item Name"
    type: string
    sql: ${TABLE}.item_name ;;
    drill_fields: [rank, sku, id]
  }

  dimension: rank {
    type: number
    sql: ${TABLE}.rank ;;
  }

  dimension: retail_price {
    type: number
    sql: ${TABLE}.retail_price ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  dimension: price_range {
    type: tier
    tiers: [0, 10, 50, 100]
    style: classic
    sql: ${retail_price} ;;
  }

  dimension: price_range_case {
    case: {
      when: {
        label: "cheap"
        sql: ${retail_price} < 10 ;;
      }
      when: {
        label: "Mid-Range"
        sql: ${retail_price} < 50 ;;
      }
      when: {
        label: "High Roller"
        sql: ${retail_price} > 100 ;;
      }
    }
  }

  dimension: department_category {
    type: string
    sql: CONCAT(${department}, ' ', ${category}) ;;
  }

  measure: count {
    type: count
    drill_fields: [id, item_name, inventory_items.count]
  }
  measure: lowest_cost_item{
    label: "Cheapest Item"
    sql: ${retail_price} ;;
    type: min
    value_format_name: usd
    drill_fields: [id, item_name]
  }
  measure: highest_cost_item{
    label: "Most Expensive Item"
    sql: ${retail_price} ;;
    type: max
    value_format_name: usd
    drill_fields: [id, item_name]
  }
  measure: average_cost_for_items {
    label: "Average Store Value"
    sql: ${retail_price} ;;
    type: average
    value_format_name: usd
    drill_fields: [id, item_name]
  }
  measure: total_value_on_hand {
    label: "Total Value"
    sql: ${retail_price} ;;
    type: sum
    drill_fields: [id, item_name]
  }
  measure: avg_cost_per_item_cmplx {
    label: "Complex average cost per item alg"
    sql: ${total_value_on_hand} /  ${average_cost_for_items} ;;
    drill_fields: [id, item_name]
  }

  measure: total_value_on_hand_distinct {
    sql: ${retail_price} ;;
    type: sum_distinct
    drill_fields: [id, item_name]
  }
}
