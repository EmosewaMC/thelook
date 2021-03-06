connection: "thelook"

# include all the views
include: "*.view"

# include all the dashboards
include: "*.dashboard"

datagroup: thelook_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "4 hours"
}

persist_with: thelook_default_datagroup

explore: inventory_items {
#   fields: [inventory_items.product_id, inventory_items.count, inventory_items.cost]
#   sql_always_where: ${cost} = '.19' ;;
  join: products {
    view_label: "Inventory Items"
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }
}

explore: order_items {
  join: inventory_items {
    view_label: "Order Items"
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: orders {
    type: left_outer
    sql_on: ${order_items.order_id} = ${orders.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: users {
    type: left_outer
    sql_on: ${orders.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: orders {
  join: users {
    view_label: "Orders"
    type: left_outer
    sql_on: ${orders.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: products {
  join: inventory_items {
    view_label: "Products"
    type: inner
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
  relationship: many_to_one
  }
}

explore: users {
#   always_filter: {
#     filters: {
#       field: gender
#       value: "m"
#     }
#   }
  join: orders {
    view_label: "Users"
    type: left_outer
    sql_on: ${orders.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}
