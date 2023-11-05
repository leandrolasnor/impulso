import React, { useState } from 'react'
import { useSelector } from "react-redux";
import Paginator from './paginator'
import Proponent from '../proponent/component'
import FormAmount from "./form_amount";
import FormUpdateProponent from './form_update_proponent';

const Grid = () => {
  const proponents = useSelector(state => state.proponents)

  const [showProponentForm, setShowProponentForm] = useState(false)
  const [showAmountForm, setShowAmountForm] = useState(false)

  const list = proponents.list.map((proponent, index) => {
    return (
      <Proponent
        key={index}
        proponent={proponent}
        showProponentForm={props => setShowProponentForm(props)}
        showAmountForm={props => setShowAmountForm(props)}
      />
    )
  })

  return(
    <React.Fragment>
      {list}
      <Paginator />
      <FormUpdateProponent subtitle="Proponent" show={showProponentForm} handleClose={() => setShowProponentForm(false)}/>
      <FormAmount subtitle="Amount" show={showAmountForm} handleClose={() => setShowAmountForm(false)}/>
    </React.Fragment>
  )
}

export default Grid
