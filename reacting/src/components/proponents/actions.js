import { toastr } from "react-redux-toastr";
import axios from 'axios'
import handle_errors from './handle_errors'

var _ = require('lodash')

export const getProponents = page => {
  return dispatch => {
    if(!page) return;
    axios.get('/v1/proponents/list', { params: { page: page, per_page: 5 } })
    .then( resp => {
      dispatch({type: 'FETCH_PROPONENTS', payload: { proponents: resp.data }})
    })
    .catch( e => handle_errors(e))
  }
}

export const getProponent = id => {
  return dispatch => {
    axios.get(`/v1/proponents/${id}`)
    .then(resp => {dispatch({type: "SHOW_PROPONENT", payload: {proponent: resp.data}})})
    .catch(e => handle_errors(e))
  }
}

export const viaCep = cep => {
  return dispatch => {
    axios.get(`https://viacep.com.br/ws/${cep}/json/`)
    .then(resp => { dispatch({type: "ADDRESS_FETCHED", payload: resp.data}) })
    .catch(e => null)
  }
}

export const discount_amount = amount => {
  return dispatch => {
    axios.get(`/v1/discount_amount/${amount}`)
    .then(resp => { dispatch({type: "DISCOUNT_AMOUNT_PREVIEW", payload: resp.data}) })
    .catch(e => null)
  }
}

export const get_report = () => {
  return dispatch => {
    axios.get('/v1/proponents/report')
    .then(resp => { dispatch({type: "REPORT_FETCHED", payload: resp.data}) })
    .catch(e => handle_errors(e))
  }
}

export const createProponent = proponent => {
  return dispatch => {
    axios.post('/v1/proponents', { proponent })
    .then( resp => {
      dispatch({type: 'CREATED_PROPONENT', payload: { proponent: resp.data }})
      toastr.success('New Proponent', _.get(resp.data, 'name', 'Created!'))
    })
    .catch( e => handle_errors(e))
  }
}

export const updateAmount = params => {
  return dispatch => {
    debugger
    axios.patch(`/v1/proponents/${params.id}/update_amount`, { ...params }).then( resp => {
      toastr.success('Proponent Amount', 'Updated')
    }).catch( e => handle_errors(e))
  }
}

export const updateProponent = proponent => {
  return dispatch => {
    axios.put(`/v1/proponents/${proponent.id}`, proponent).then( resp => {
      let {name, taxpayer_number} = resp.data
      dispatch({type: 'PROPONENT_UPDATED', payload: {proponent: resp.data}})
      toastr.success('Proponent Updated!', `${name} | ${taxpayer_number}`)
    }).catch( e => handle_errors(e))
  }
}

export const createPartitionedVacation = partitioned => {
  return dispatch => {
    axios.post('/vacation/partitioned_schedule', { ...partitioned }).then( resp => {
      toastr.success('Partitioned Vacation', 'Created!')
    }).catch( e => handle_errors(e))
  }
}

export const fireProponent = id => {
  return dispatch => {
    axios.delete(`/v1/proponents/${id}`)
    .then( resp => {
      dispatch({type: 'PROPONENT_FIRED', payload: { proponent: resp.data }})
    })
    .catch( e => handle_errors(e))
  }
}
