view: products {
  sql_table_name: thelook.products ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: brand {
    type: string
    sql: ${TABLE}.brand ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
  }

  dimension: item_name {
    type: string
    sql: ${TABLE}.item_name ;;
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
    sql: ${retail_price} ;;
    type: min
    value_format_name: usd

  }
  measure: highest_cost_item{
    sql: ${retail_price} ;;
    type: max
    value_format_name: usd

  }
  measure: average_cost_for_items {
    sql: ${retail_price} ;;
    type: average
    value_format_name: usd
  }
  measure: total_value_on_hand {
    sql: ${retail_price} ;;
    type: sum
  }
  measure: avg_cost_per_item_cmplx {
    sql: ${average_cost_for_items} / ${total_value_on_hand} ;;
  }

  measure: total_value_on_hand_distinct {
    sql: ${retail_price} ;;
    type: sum_distinct
  }
}
