import { useEffect } from 'react'
import { useSelector } from 'react-redux'
import { updateProponent, getProponent, viaCep } from "./actions"
import { Modal, Card, Row, Col, Container, Form, Button, FloatingLabel } from "react-bootstrap"
import { useDispatch } from "react-redux";
import { useForm } from "react-hook-form"

const _ = require("lodash")

let FormUpdateProponent = (props) => {
  const dispatch = useDispatch()
  const {title, show, handleClose} = props
  const { id, name, birthdate, taxpayer_number } = props.show
  const {register, handleSubmit, reset, getValues} = useForm()
  const proponents = useSelector(state => state.proponents)
  const { proponent, via_cep } = proponents

  useEffect(() => {
    if(id) dispatch(getProponent(id))
  }, [id])

  useEffect(() => {
    if(proponent){
      reset(
        {
          name: proponent.name,
          birthdate: birthdate,
          taxpayer_number: taxpayer_number,
          contacts_attributes: [..._.get(proponent, 'contacts')],
          addresses_attributes: [..._.get(proponent, 'addresses')]
        }
      );
    }
  }, [proponent]);

  useEffect(() => {
    if(via_cep){
      reset(
        {
          addresses_attributes: [
            {
              zip: _.get(via_cep, 'cep'),
              address: _.get(via_cep, 'logradouro'),
              city: _.get(via_cep, 'localidade'),
              state: _.get(via_cep, 'uf'),
              district: _.get(via_cep, 'bairro'),
            }
          ]
        }
      );
    }
  }, [via_cep]);

  return (
    <Col>
      <Modal size="md" centered show={show} onHide={handleClose}>
        <Modal.Header closeButton>
          <Modal.Title id="contained-modal-title-vcenter">
            <blockquote className="blockquote mb-0">
              <p className="mb-0">{name}</p>
              <footer className="mt-0 blockquote-footer">{taxpayer_number}</footer>
            </blockquote>
          </Modal.Title>
        </Modal.Header>
        <Modal.Body className="show-grid">
          <Container>
            <Form onSubmit={handleSubmit(data => dispatch([updateProponent({...data, id: id}), reset(), handleClose()]))}>
              <Row>
                <Card>
                  <Card.Body>
                    <Form.Group>
                      <Row>
                        <Col>
                          <FloatingLabel label="name">
                            <Form.Control placeholder="name" {...register('name')} />
                          </FloatingLabel>
                        </Col>
                      </Row>
                      <Row>
                        <Col className='mt-2'>
                          <FloatingLabel label="birthdate">
                            <Form.Control type="date" placeholder="birthdate" {...register('birthdate')} />
                          </FloatingLabel>
                        </Col>
                      </Row>
                      <Row>
                        <Col className='mt-2'>
                          <FloatingLabel label="contact">
                            <Form.Control placeholder="contact" {...register('contacts_attributes[0].number')} />
                            <Form.Control type="hidden" {...register('contacts_attributes[0].id')} />
                          </FloatingLabel>
                        </Col>
                      </Row>
                      <Row>
                        <Col className='mt-2'>
                          <FloatingLabel label="zip">
                            <Form.Control onMouseLeave={() => dispatch(viaCep(getValues('addresses_attributes[0].zip')))} placeholder="zip" {...register('addresses_attributes[0].zip')} />
                            <Form.Control type="hidden" {...register('addresses_attributes[0].id')} />
                          </FloatingLabel>
                        </Col>
                      </Row>
                      <Row>
                        <Col className='mt-2'>
                          <FloatingLabel label="address">
                            <Form.Control placeholder="address" {...register('addresses_attributes[0].address')} />
                          </FloatingLabel>
                        </Col>
                      </Row>
                      <Row>
                        <Col className='mt-2 lg-6'>
                          <FloatingLabel label="district">
                            <Form.Control placeholder="district" {...register('addresses_attributes[0].district')} />
                          </FloatingLabel>
                        </Col>
                        <Col className='mt-2 lg-6'>
                          <FloatingLabel label="number">
                            <Form.Control placeholder="number" {...register('addresses_attributes[0].number')} />
                          </FloatingLabel>
                        </Col>
                      </Row>
                      <Row>
                        <Col className='mt-2 lg-6'>
                          <FloatingLabel label="state">
                            <Form.Control placeholder="state" {...register('addresses_attributes[0].state')} />
                          </FloatingLabel>
                        </Col>
                        <Col className='mt-2 lg-6'>
                          <FloatingLabel label="city">
                            <Form.Control placeholder="city" {...register('addresses_attributes[0].city')} />
                          </FloatingLabel>
                        </Col>
                      </Row>
                    </Form.Group>
                  </Card.Body>
                </Card>
              </Row>
              <Row>
                <Button className='mt-3' variant="success" type="submit">Update Proponent</Button>
              </Row>
            </Form>
          </Container>
        </Modal.Body>
        <Modal.Footer>
        </Modal.Footer>
      </Modal>
    </Col>
  )
}

export default FormUpdateProponent;
