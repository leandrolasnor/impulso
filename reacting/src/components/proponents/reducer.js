const _ = require('lodash')

const INITIAL_STATE = {
  list: [],
  complete: false,
  proponent: null,
  via_cep: null,
  discount_amount_preview: null,
  report: 'teste'
};

let proponents;

var reducer = (state = INITIAL_STATE, action) => {
  switch (action.type) {
    case "FETCH_PROPONENTS":
      return {
        ...state,
        list: [
          ...state.list,
          ...action.payload.proponents
        ],
        complete: action.payload.proponents.length === 0
      }
    case "ADDRESS_FETCHED":
      return _.get(action.payload, 'erro') === true ? {...state, via_cep: null} : {...state, via_cep: action.payload}
    case "REPORT_FETCHED":
      return {...state, report: action.payload}
    case "DISCOUNT_AMOUNT_PREVIEW":
      return {...state, discount_amount_preview: action.payload}
    case "PROPONENT_UPDATED":
      proponents = state.list.filter(e => e.id !== action.payload.proponent.id)
      proponents = [...proponents, action.payload.proponent].sort((a,b) => b.id - a.id)
      return {...state, list: [...proponents]}
    case "SHOW_PROPONENT":
      return {...state, proponent: action.payload.proponent}
    case "PROPONENT_FIRED":
      proponents = state.list.filter(e => e.id !== action.payload.proponent.id)
      proponents = [...proponents, { ...action.payload.proponent, fired: true }].sort((a,b) => b.id - a.id)
      return {...state, list: [...proponents]}
    case "CREATED_PROPONENT":
      return {
        ...state,
        list: [action.payload.proponent, ...state.list]
      }
    default:
      return state;
  }
}

export default reducer;
