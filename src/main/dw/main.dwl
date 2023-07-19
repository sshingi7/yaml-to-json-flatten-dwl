%dw 2.0
output application/json

fun convertNestedToObjectString(obj, previousKey = "") =
  obj mapObject (value, key, index) -> {
    (key): if ((value is Object) and !(isEmpty(value)))
      convertNestedToObjectString(value, if (previousKey == "") key else previousKey ++ "." ++ key)
    else {
      (if (previousKey == "") key else previousKey ++ "." ++ key): value
    }
  }


fun flattenObject(inputObject, resultObject = {}) =
  inputObject match {
    case is Object -> 
      resultObject ++ (
        $ mapObject (
          (value, key, index) -> if (value is String) ({(key): value}) else flattenObject(value, resultObject)
        )
      )
    else -> resultObject
  }

---
flattenObject(convertNestedToObjectString(payload))