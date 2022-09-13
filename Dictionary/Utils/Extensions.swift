//
//  Extensions.swift
//  Dictionary
//
//  Created by Matheus Xavier on 12/09/22.
//

import Foundation
import UIKit

extension UIView {

    /// Método de alinhamento de uma view
    /// - Parameters:
    ///   - top: NSLayoutYAxisAnchor, Âncora superior
    ///   - left: NSLayoutYAxisAnchor, Âncora esquerda
    ///   - bottom: NSLayoutYAxisAnchor, Âncora inferior
    ///   - right: NSLayoutYAxisAnchor,  Âncora direita
    ///   - paddingTop: CGFloat, espaço da âncora superior
    ///   - paddingLeft:  CGFloat, espaço da âncora esquerda
    ///   - paddingBottom:  CGFloat, espaço da âncora inferior
    ///   - paddingRight:  CGFloat, espaço da âncora direita
    ///   - width:  CGFloat, tamanho da largura
    ///   - height: CGFloat, tamanho da altura
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    /// Método de alinhamento ao eixo X.
    /// - Parameter view: CGFloat -> View ao qual será a referência do alinhamento
    func centerX(inView view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    /// Método de alinhamento ao eixo Y.
    /// - Parameters:
    ///   - view: CGFloat -> View ao qual será a referência do alinhamento
    ///   - leftAnchor: CGFloat -> Escala no vértice Y o conteúdo
    ///   - paddingLeft: CGFloat -> Determina o ponto de ancoragem da margin esquerda
    ///   - constant: CGFLoat -> Escala no vértice X o conteúdo em relação à esquerda
    func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil,
                 paddingLeft: CGFloat = 0, constant: CGFloat = 0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
        
        if let left = leftAnchor {
            anchor(left: left, paddingLeft: paddingLeft)
        }
    }
    
    /// Método de dimensionamento.
    /// - Parameters:
    ///   - height: CGFloat -> Escala o frame da view para preencher a constraint de altura equivalente ao valor passado
    ///   - width: CGFloat -> Escala o frame da view para preencher a constraint de comprimento equivalente ao valor passado
    func setDimensions(height: CGFloat?, width: CGFloat?) {
        translatesAutoresizingMaskIntoConstraints = false
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}

extension URLSession {
    enum APIError: Error {
        case serverError(Int)
        case transporterError(Error)
    }
    
    typealias DataTaskResult = Result<(HTTPURLResponse, Data), Error>
    
    /// Define o resultado de uma DataTask modificando a URLSession. A partir da nova dataTask é possível filtrar quando a API retornar um erro entre os códigos 300 e 599 e quando ela retornar sucesso entre os códigos 200 e 299.
    /// - Parameters:
    ///   - request: Request a ser feita.
    ///   - completionHandler: Executado após a finalização da request.
    /// - Returns: Retorna um typealias pra DataTaskResult que possui a response, o objeto data e o possível erro.
    func dataTask(with request: URLRequest, completionHandler: @escaping (DataTaskResult) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: request) { data, response, error in
            if let error = error {
                completionHandler(Result.failure(APIError.transporterError(error)))
                return
            }
            let response = response as! HTTPURLResponse
            let status  = response.statusCode
            guard (200...299).contains(status) else {
                completionHandler(Result.failure(APIError.serverError(status)))
                return
            }
            completionHandler(Result.success((response, data!)))
        }
    }
}
