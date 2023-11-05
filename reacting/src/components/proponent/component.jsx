import React from 'react'
import { useDispatch } from "react-redux";
import { fireProponent } from '../proponents/actions'
import { Col, Card, Button } from "react-bootstrap";
import styled from 'styled-components'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { faUser } from '@fortawesome/free-solid-svg-icons'

const OpaqueCard = styled(Card)`
  background-color: rgba(230, 250, 200, 0.6)
`
const ButtonFire = props => {
  const {fired, onClick} = props
  return (fired ? <span>Fired!</span> : <Button variant="outline-danger" onClick={onClick}>Fire!</Button>)
}
const Name = props => {
  const {fired, name} = props
  return (fired ? <s>{name}</s> : <h2>{ name }</h2>)
}

const Proponent = (props) => {
  const dispatch = useDispatch()

  const {id, name, birthdate, amount, fired} = props.proponent
  const {showAmountForm, showProponentForm} = props

  return(
    <OpaqueCard bg={fired ? 'danger' : ''} className="my-2">
      <Card.Body>
        <Card.Title className="d-flex justify-content-between">
          <Name fired={fired} name={name} />
          <Col lg={1} className="d-flex justify-content-end">
            <ButtonFire fired={fired} onClick={() => dispatch(fireProponent(id))}/>
          </Col>
        </Card.Title>
        <Card.Subtitle className="mb-2 text-muted">
          {birthdate} <Card.Link href="#" onClick={() => showProponentForm(props.proponent)}><FontAwesomeIcon icon={faUser} /></Card.Link>
        </Card.Subtitle>
      </Card.Body>
      <Card.Body>
        <Card.Link href="#" onClick={() => showAmountForm(props.proponent)}>{amount}</Card.Link>
      </Card.Body>
    </OpaqueCard>
  )
}

export default Proponent
