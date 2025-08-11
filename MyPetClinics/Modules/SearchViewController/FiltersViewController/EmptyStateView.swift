//
//  EmptyStateView.swift
//  MyPetClinics
//
//  Created by Dmitry Dmitry on 10.8.2025.
//

import UIKit

enum EmptyStateMode {
    case textOnly      // только заголовок
    case withActions   // заголовок + сабтайтл + кнопки
}

final class EmptyStateView: UIView {
    
    // MARK: - Public Closures
    var onChangeFiltersTapped: (() -> Void)?
    var onClearFiltersTapped: (() -> Void)?
    
    // MARK: - Subviews
    private let titleLabel = Labels(
        style: .stubLabelStyle,
        text: String(localized: "nothing_found")
    )
    
    private let subtitleLabel: Labels = {
        let label = Labels(
            style: .ordinaryText17LabelStyle,
            text: String(localized: "try_changing_filters_or_query")
        )
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private lazy var changeFiltersButton = Buttons(
        style: .primary20(title: String(localized: "change_filters_title")),
        target: self,
        action: #selector(changeFiltersTapped)
    )
    
    private lazy var clearFiltersButton = Buttons(
        style: .primary20(title: String(localized: "clear_filters_title")),
        target: self,
        action: #selector(clearFiltersTapped)
    )
    
    // Контейнеры: вертикальный стек + горизонтальный ряд для кнопок
    private let verticalStack = StackViews(style: .verticalCenterStackView)
    private let buttonsRowStack = StackViews(style: .horizontal6StackView) // fillEqually
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewsAndConstraints()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Configure
    func configure(mode: EmptyStateMode) {
        let showActions = (mode == .withActions)
        subtitleLabel.isHidden = !showActions
        buttonsRowStack.isHidden = !showActions
    }
    
    // MARK: - Actions
    @objc private func changeFiltersTapped() { onChangeFiltersTapped?() }
    @objc private func clearFiltersTapped()  { onClearFiltersTapped?() }
}

// MARK: - Layout
private extension EmptyStateView {
    func setupViewsAndConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        
        // Кнопки в ряд
        buttonsRowStack.isHidden = true
        buttonsRowStack.addArrangedSubview(changeFiltersButton)
        buttonsRowStack.addArrangedSubview(clearFiltersButton)
        
        // Основной вертикальный стек
        verticalStack.spacing = 12
        [titleLabel, subtitleLabel, buttonsRowStack].forEach {
            verticalStack.addArrangedSubview($0)
        }
        
        addSubview(verticalStack)
        NSLayoutConstraint.activate([
            verticalStack.topAnchor.constraint(equalTo: topAnchor),
            verticalStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            verticalStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            verticalStack.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor)
        ])
    }
}
